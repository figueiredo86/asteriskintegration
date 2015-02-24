#!/usr/bin/perl

 require LWP::UserAgent;
 
 my $connect = new LWP::UserAgent;

 my $url = "https://apps.agnet.com.br/WebServices/Usuarios/Usuarios.asmx";

 $connect->protocols_allowed( ['http','https'] );
 $connect->credentials(
  'https://apps.agnet.com.br/WebServices/Usuarios/Usuarios.asmx?op=ConfirmarInformacoesParaReset',
  'realm',
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
 print $wspost->content."\n"; 
