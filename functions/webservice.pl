#!/usr/bin/perl

use LWP::Debug;
use LWP::UserAgent;
use Mozilla::CA;
use HTTP::Request::Common;

my $connect = new LWP::UserAgent();

my $url = "https://apps.agnet.com.br/WebServices/Usuarios/Usuarios.asmx?op=ConfirmarInformacoesParaReset";

$connect->protocols_allowed( ['https'] );
$connect->credentials(
 "http://apps.agnet.com.br:443",
 '',
 "AGDOMAIN\_srvWebServicesAG",
 'agsenha'
);

my %wsparams = (
 'matricula' => '33344455567',
 'cpf' => '33344455567',
 'rg' => '334445556',
 'idade' => '29'
);

my $wspost = $connect->post($url, \%wsparams);

print $wspost->as_string."\n"; 
