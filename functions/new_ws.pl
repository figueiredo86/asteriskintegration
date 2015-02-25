#!/usr/bin/perl
use SOAP::Lite;

my $soap = SOAP::Lite->new('proxy' => [
                        'https://apps.agnet.com.br/WebServices/Usuarios/Usuarios.asmx?op=ConfirmarInformacoesParaReset',
                        'credentials' => [
                                "https://apps.agnet.com.br/WebServices/Usuarios/Usuarios.asmx?op=ConfirmarInformacoesParaReset:443",
                                "",
                                "AGDOMAIN\_srvWebServicesAG",
                                "agsenha"
                        ]
                ]);
my $som = $soap->RetrieveList();
die $som->faultstring if ($som->fault);
print $som->result, "\n";
