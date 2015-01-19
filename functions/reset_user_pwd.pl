#!/usr/bin/perl -w

sub ldap() {
 
 my $username = $_[0];
 my $passwd = $_[1];
  
 my $adsvr='';
 my $adbinddn="cn="$adcn",dc=$addc0,dc=$addc1";
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
  base   => "cn=users,dc=$addc0,dc=$addc1",
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
}
