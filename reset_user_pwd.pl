#!/usr/bin/perl -w
#
# changing user passwords in AD
#
use strict;
use Net::LDAP;
use Asterisk::AGI;
use Config::Tiny;


# module needed to encode AD password
use Unicode::String qw(utf8);
#
# ARGV is username password
my $username = $ARGV[0];
my $passwd = $ARGV[1];
 
my $adsvr='dc1.example.net';
my $adbinddn='cn=administrator,cn=users,dc=example,dc=net';
my $adpw='youradministratorpassword';
 
# Connect to the AD server
my $ad=Net::LDAP->new($adsvr,
                      version => 3,
                      scheme  => 'ldaps',
                      port    => 636,
                     )
  or die "can't connect to $adsvr: $@";
# Bind as Administrator
$result=$ad->bind($adbinddn, password=>$adpw);
if ($result->code) {
  LDAPerror ("binding",$result);
  exit 1;
};
 
# check for username, get DN
$result = $ad->search(
                       base   => "cn=users,dc=example,dc=net",
                       filter => "(samAccountName=$username)",
                       attrs  => ['distinguishedName']
                       );
$result->code && die $result->error;
if ($result->entries != 1 ) { die "ERROR: User not found in AD: $username" };
 
my $entry = $result->entry(0); # there can be only one
my $dn = $entry->get_value('distinguishedName');
 
my $unicodePwd = utf8(chr(34).${passwd}.chr(34))->utf16le();
 
# change password entries etc.
$result = $ad->modify(
                       $dn,
                       replace => {
                                    unicodePwd       => $unicodePwd,
                                  }
                       );
 
$result->code && die $result->error;
print "AD  : SUCCESS: ${username} password changed.n";
 
$ad->unbind()
