import 'package:flutter/material.dart';
import 'package:louvor_app/helpers/dialog_utils.dart';
import 'package:louvor_app/helpers/validators.dart';
import 'package:louvor_app/models/user_app.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
      ),
      body:
          Column(
            children: [
              Center(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: formKey,
                    child: Consumer<UserManager>(
                      builder: (_, userManager, child){
                        return ListView(
                          padding: const EdgeInsets.all(16),
                          shrinkWrap: true,
                          children: <Widget>[
                            TextFormField(
                              controller: emailController,
                              enabled: !userManager.loading,
                              decoration: const InputDecoration(hintText: 'E-mail',
                                                                prefixIcon: Icon(Icons.email),
                                                                ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              validator: (email){
                                if(!emailValid(email!))
                                  return 'E-mail inválido';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16,),
                            TextFormField(
                              controller: passController,
                              enabled: !userManager.loading,
                              decoration: const InputDecoration(hintText: 'Senha',
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                              autocorrect: false,
                              obscureText: true,
                              validator: (pass){
                                if(pass!.isEmpty || pass.length < 6)
                                  return 'Senha inválida';
                                return null;
                              },
                            ),
                            //child,
                            const SizedBox(height: 16,),
                            SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: userManager.loading ? null : (){
                                  if(formKey.currentState!.validate()){
                                    userManager.signIn(
                                        userApp: UserApp(
                                            email: emailController.text,
                                            password: passController.text
                                        ),
                                        onFail: (e){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                        content: Text('Falha ao entrar: $e'),
                                                        backgroundColor: Colors.red,
                                                )
                                          );
                                        },
                                        onSuccess: (){
                                          Navigator.of(context).pop();
                                        }
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  textStyle: TextStyle( color: Colors.white),
                                  //todo arrumar
                                  //disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                                ),
                                child: userManager.loading ?
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ) :
                                const Text(
                                  'Entrar',
                                  style: TextStyle(
                                      fontSize: 18
                                  ),
                                ),
                              ),
                            ),

                            Align(
                                alignment: Alignment.centerRight,
                                child: Padding(padding: const EdgeInsets.all(18),
                                    child:
                                    GestureDetector(
                                      onTap:(){
                                        if(!emailValid(emailController.text)){
                                          DialogUtils.alert(context, 'Email inválido.', 'O email: ${emailController.text}, não é válido', 'Ok');
                                        }else {
                                          UserManager.resetPassword(emailController.text);
                                          DialogUtils.alert(context, 'Recuperação de senha', 'Foi enviado um link, para o email: ${emailController.text}.\nLá você poderá alterar sua senha, para acessar Louvor App', 'Ok');
                                        }
                                      },
                                      child: const Text('Esqueci minha senha'),
                                    )

                                )
                            ),

                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          )
    );
  }
}