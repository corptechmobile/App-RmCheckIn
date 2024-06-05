# Matheus

- [x] Identificação do tipo de login
	- CPF
	- Telefone
	- Email
- [x] Login por cpf
- [x] Registrar checkins no login
- [x] Ajudar danilo com refresh da tela
- [x] Notificações
- [x] Lógica para deletar ids antigos
```dart
"delete from nf_compra
where id_checkin in (
select id_checkin
from checkin
where dtEntrada < ${ DateTime.now().milissecondssinceepoch - 30 * 24 * 60 * 60 * 1000 }
);"

"delete from checkin
where dtEntrada < ${ DateTime.now().milissecondssinceepoch - 30 * 24 * 60 * 60 * 1000 };"
```
# Danilo

- [x] Refresh da tela (status)
- [x] Leitor de QRCode pela câmera
- [x] Exclusão da nota
- [x] Revisar Layout
- [x] Alteração de senha no app
- [ ] Fazer as notificações funcionarem no iphone
	- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications#-ios-setup)
	- [workmanager](https://github.com/fluttercommunity/flutter_workmanager/blob/master/IOS_SETUP.md)
# Qualquer um

