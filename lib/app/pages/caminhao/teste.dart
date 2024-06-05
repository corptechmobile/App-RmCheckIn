/* import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmcheckin/app/model/motorista_auth_model.dart';

import '../../widget/app_color.dart';

class VeiculoRedeCard extends StatelessWidget {
  final Motorista motorista;

  const VeiculoRedeCard({super.key, required this.motorista});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Dados do caminhao',
              style: GoogleFonts.dosis(
                textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: darkBlueColor),
              ),
            ),
          ),
          Card(
            elevation: 10,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: motorista.veiculos.length,
              itemBuilder: (context, index) {
                final veiculo = motorista.veiculos[index];
                final rede = motorista.redes[index];
                return ListTile(
                  title: Row(
                    children: [
                      if (veiculo.foto.isNotEmpty)
                        CircleAvatar(
                          backgroundImage: NetworkImage(veiculo.foto),
                        )
                      else
                        const Icon(Icons.image),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(veiculo.tipoVeiculo),
                          Text(veiculo.placa),
                          Text(rede.descricao),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
 */