#!/usr/bin/perl -w

use strict;
use Net::LDAP;
#use Asterisk::AGI;
use Config::Tiny;
use Unicode::String qw(utf8);

my $confile = Config::Tiny->new;

$confile = Config::Tiny->read('/home/asteriskintegration/properties.ini');
$adadminuser = $confile->{ad}->{adadminuser};
$adadminpasswd = $confile->{ad}->{adadminpasswd};
$adhost = $confile->{ad}->{adhost};


my $username = $ARGV[0];
my $passwd = $ARGV[1];
 
my $adsvr='';
my $adbinddn="cn=$adadminuser,cn=,dc=stefanini,dc=dom";
my $adpw=$adadminpasswd;
 

# Connect to the AD server
my $ad=Net::LDAP->new(
 $adsvr,
 version => 3,
 scheme  => 'ldaps',
 port    => 636,
) or die "can't connect to $adsvr: $@";

# Bind as Administrator
$result=$ad->bind($adbinddn, password=>$adpw);

if ($result->code) {
 LDAPerror ("binding",$result);
 exit 1;
};
 
# check for username, get DN
$result = $ad->search(
 base   => "cn=users,dc=stefanini,dc=dom",
 filter => "(samAccountName=$username)",
 attrs  => ['distinguishedName']
);
$result->code && die $result->error;

if ($result->entries != 1 ) { 
 die "ERROR: User not found in AD: $username" 
};
 
my $entry = $result->entry(0);
my $dn = $entry->get_value('distinguishedName');
 
my $unicodePwd = utf8(chr(34).${passwd}.chr(34))->utf16le();
 
# change password entries etc.
$result = $ad->modify(
                       $dn,
                       replace => {
                                    #unicodePwd       => $unicodePwd,
                                    pwd		      => $unicodePwd,
                                  }
                       );
 
$result->code && die $result->error;
print "AD  : SUCCESS: ${username} password changed.n";
 
$ad->unbind()

