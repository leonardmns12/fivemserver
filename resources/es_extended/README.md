# es_extended

es_extended é um roleplay framework para o FiveM. ESX é curto para o EssentialMode Extended. A estrutura a seguir para criar um servidor roleplay baseado em economia no FiveM e também o mais popular na plataforma!

Apresentando muitos recursos extras para atender servidores de interpretação de papéis, aqui está uma amostra do que está disponível:

- esx_ambulancejob: jogue como médico para reviver jogadores que estão sangrando. Completo com garagens e sistema de reaparecimento e sangria
- esx_policejob: patrulhe a cidade e prenda jogadores que cometem crimes, com arsenal, vestiários e garagens
- esx_vehicleshop: roleplay trabalhando em uma concessionária de veículos onde você vende carros para os jogadores

O ESX foi desenvolvido inicialmente por Gizz em 2017 para seu amigo, pois estava criando um servidor FiveM e não havia nenhuma estrutura de interpretação econômica disponível. O código original foi escrito em uma semana ou duas e, posteriormente, de código aberto, desde então, foi aprimorado e as partes foram reescritas para melhorar ainda mais.

# Servidores Iceline Hosting e ESX Brasil

![Iceline hosting](https://cdn.discordapp.com/attachments/704310570098229309/704331510203023490/banner.gif)

Você está pensando em abrir um servidor FiveM por conta própria? 
[Iceline Hosting](https://iceline-hosting.com/billing/aff.php?aff=122) fornece servidores de jogos, VPS de jogos de ponta com proteção contra DDoS incluída e muito mais!

Existe um complemento de suporte gerenciado opcional disponível para servidores de jogos e VPS de jogos que adicionam os seguintes serviços:

- Investigação e correção de erros em relação ao servidor ou scripts de terceiros
- Instalando scripts ou software de terceiros
- Recuperação de dados perdidos

Vá para [Iceline Hosting](https://iceline-hosting.com/billing/aff.php?aff=122) e use o código promocional `ESXBRAZIL` para ganha 20% no primeiro mês em servidor.
Ele da descontos em outros serviços da empresa.

## Links e Leia mais

- [ESX Documentation](https://esx-brasil.github.io/)
- [ESX Development Discord](https://discord.gg/ZGXTsdN)
- [FiveM Native Reference](https://runtime.fivem.net/doc/reference.html)

## Recursos

- Sistema de inventário baseado em peso
- Suporte de armas, incluindo suporte para acessórios e tonalidades
- Suporta diferentes contas monetárias (padronizadas com dinheiro, banco e dinheiro preto)
- Muitos recursos oficiais disponíveis no nosso GitHub
- Sistema de trabalho, com notas e suporte de roupas
- Suporta vários idiomas, a maioria das strings são localizadas
- API fácil de usar para que os desenvolvedores integrem facilmente o ESX aos seus projetos
- Registre seus próprios comandos facilmente, com validação de argumento, sugestão de bate-papo e usando FXServer ACL

## Requisitos

- [mysql-async](https://github.com/ESX-Brasil/mysql-async)
- [async](https://github.com/ESX-Brasil/async)

## Download e Instalação

### Usando [fvm](https://github.com/qlaffont/fvm-installer)

```
fvm install --save --folder=essential esx-brasil/es_extended
fvm install --save --folder=esx esx-brasil/esx_menu_default
fvm install --save --folder=esx esx-brasil/esx_menu_dialog
fvm install --save --folder=esx esx-brasil/esx_menu_list
```

### Usando Git

```
cd resources
git clone https://github.com/ESX-Brasil/es_extended [essential]/es_extended
git clone https://github.com/ESX-Brasil/esx_menu_default [esx]/[ui]/esx_menu_default
git clone https://github.com/ESX-Brasil/esx_menu_dialog [esx]/[ui]/esx_menu_dialog
git clone https://github.com/ESX-Brasil/esx_menu_list [esx]/[ui]/esx_menu_list
```

### Manualmente

- Download https://github.com/ESX-Brasil/es_extended/releases/latest
- Coloque-o no diretório `resource/[essential]`
- Download https://github.com/ESX-Brasil/esx_menu_default/releases/latest
- Coloque-o no diretório `resource/[esx]/[ui]`
- Download https://github.com/ESX-Brasil/esx_menu_dialog/releases/latest
- Coloque-o no diretório `resource/[esx]/[ui]`
- Download https://github.com/ESX-Brasil/esx_menu_list/releases/latest
- Coloque-o no diretório `resource/[esx]/[ui]`

### Instalação

- Importe `es_extended.sql` no seu banco de dados
- Configure seu `server.cfg` para ficar assim

```
add_principal group.admin group.user
add_ace resource.es_extended command.add_ace allow
add_ace resource.es_extended command.add_principal allow
add_ace resource.es_extended command.remove_principal allow

start mysql-async
start es_extended

start esx_menu_default
start esx_menu_list
start esx_menu_dialog
```
# Discord

[![Join ESX Brasil](https://discordapp.com/api/guilds/693468263161659402/embed.png?style=banner2)](https://discord.gg/ZGXTsdN)

## Legal

### License

es_extended - EssentialMode Extended framework for FiveM

Copyright (C) 2015-2020 ESXBrasil

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.
