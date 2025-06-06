import 'package:alertacoe/assets/network_image.dart';
import 'package:alertacoe/helper/urlScheme.dart';
import 'package:alertacoe/views/profile/profile.dart';
import 'package:flutter/material.dart';
import '../../helper/applicationDefault.dart';
import '../../helper/globalState.dart';

class AboutPage extends StatefulWidget {
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProfileHeader(
                key: UniqueKey(),
                coverImage: NetworkImage(
                    GlobalState.getInstance().baseUrlImage + "logo-coe.png"),
                title: GlobalState.getInstance().appName,
                subtitle: GlobalState.getInstance().appVersion,
                actions: <Widget>[],
                avatar: NetworkImage(
                  GlobalState.getInstance().baseUrlImage + "logo-coe.png",
                ),
              ),
              const SizedBox(height: 10.0),
              BuildInfo(),
            ],
          ),
        ));
  }
}

class BuildInfo extends StatelessWidget {
  final app = ApplicationDefault();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: Text(
              "Esta aplicación contó con el apoyo del Pueblo de los Estados Unidos de América, a través de su Agencia para el Desarrollo Internacional (USAID), y su socio implementador Fundación REDDOM.",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Para Contacto:",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              UrlScheme.makePhoneCall("809-472-0909");
                            },
                            child: Text("809-472-0909",
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              UrlScheme.email("alertacoe@coe.gob.do");
                            },
                            child: Text("alertacoe@coe.gob.do",
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              app.navigateToWebView(context,
                                  "http://coe.gob.do", "http://coe.gob.do");
                            },
                            child: Text(
                              "http://coe.gob.do",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          app.navigateToWithWidget(context,
                              "Contactos de Emergencias", EmergencyContacts() as Widget);
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 30,
                            ),
                            Container(
                              width: 100,
                              child: Text(
                                "Contactos Emergencias",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: MaterialButton(
                              color: Colors.transparent,
                              elevation: 0,
                              onPressed: () {
                                app.navigateToWebView(
                                    context,
                                    "https://www.usaid.gov",
                                    "https://www.usaid.gov");
                              },
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                child: PNetworkImage(
                                    "https://www.usaid.gov/sites/all/themes/usaid/logo.png",
                                    fit: BoxFit.contain,
                                    height: 50,
                                    width: 100,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: MaterialButton(
                              color: Colors.transparent,
                              elevation: 0,
                              onPressed: () {
                                app.navigateToWebView(
                                    context,
                                    "http://fundacionreddom.org",
                                    "http://fundacionreddom.org");
                              },
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                child: PNetworkImage(
                                    "http://fundacionreddom.org/wp-content/uploads/2016/02/logo_reddom_rgb.png",
                                    fit: BoxFit.contain,
                                    height: 50,
                                    width: 100,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Text(
                    "Alerta Marino Costera",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text("Versión 1.0",
                      style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "PROYECTO DE REDUCCIÓN DE RIESGOS BASADA EN ECOSISTEMAS EN ZONAS COSTERAS DE LAS PROVINCIAS DE SAMANÁ Y LA ALTAGRACIA DE LA REPÚBLICA DOMINICANA.",
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: MaterialButton(
                              color: Colors.transparent,
                              elevation: 0,
                              onPressed: () {
                                app.navigateToWebView(
                                    context,
                                    "https://www.caribbeanbiodiversityfund.org",
                                    "https://www.caribbeanbiodiversityfund.org");
                              },
                                                        child: PNetworkImage(
                                                            "${GlobalState.getInstance().baseUrlImage}CBF_Logo_2.jpeg",
                                                            fit: BoxFit.contain,
                                                            height: 50,
                                                            width: 100,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                          
                          class EmergencyContacts {
                          }
             