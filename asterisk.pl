#!/usr/bin/perl -w

use strict;
use Net::LDAP;
use Asterisk::AGI;
use Config::Tiny;
use Unicode::String qw(utf8);

eval 'require "/home/asteriskintegration/functions/reset_user_pwd.pl"'


my $confile = Config::Tiny->new;

$confile = Config::Tiny->read('/home/asteriskintegration/properties.ini');
$adadminuser = $confile->{ad}->{adadminuser};
$adadminpasswd = $confile->{ad}->{adadminpasswd};
$adhost = $confile->{ad}->{adhost};
$adcn = $confile->{ad}->{adcn};
$addc0 = $confile->{ad}->{addc0};
$addc1 = $confile->{ad}->{addc1};

&ldap($ARGV[0],$ARGV[1]);
