#!/usr/bin/perl

use LWP::UserAgent;
use Mozilla::CA;

my $connect = new LWP::UserAgent(keep_alive=>1);

my $url = "https://apps.agnet.com.br/WebServices/Usuarios/Usuarios.asmx?op=ConfirmarInformacoesParaReset";

$connect->protocols_allowed( ['http','https'] );
$connect->credentials(
 'https://apps.agnet.com.br/WebServices/Usuarios/Usuarios.asmx:443',
 '',
 'AGDOMAIN\_srvWebServicesAG',
 'agsenha'  
);

my %wsparams = (
 'matricula' => '33344455567',
 'cpf' => '33344455567',
 'rg' => '334445556',
 'idade' => '29'
);

my $wspost = $connect->post($url, \%wsparams);

print $wspost->message."\n"; 
print $wspost->code."\n"; 
print $wspost->as_string."\n"; 
