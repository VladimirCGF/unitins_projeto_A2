import 'package:flutter/material.dart';
import 'package:unitins_projeto/pages/CourseSelectionScreen.dart';
import 'package:unitins_projeto/utils/app_routes.dart';

import '../components/app_drawer.dart';
import '../components/custom_card.dart';
import '../components/custom_footer.dart';
import 'grade_curricular_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://www.unitins.br/uniPerfil/Logomarca/Imagem/09997c779523a61bd01bb69b0a789242',
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue.shade900,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.blue.shade900,
          tabs: const [
            Tab(text: 'Meus Aplicativos'),
            Tab(text: 'Meus Tutoriais'),
          ],
        ),
      ),
      drawer: const AppDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAplicativos(),
          const Center(child: Text('Tutoriais ainda não disponíveis.')),
        ],
      ),
    );
  }

  Widget _buildAplicativos() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Secretaria',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                        color: Color(0xFF094AB2),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomCard(
                      title: 'BOLETIM (SEMESTRE ATUAL)',
                      description:
                          'Desempenho nas disciplinas do semestre atual.',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const CourseSelectionScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomCard(
                      title: 'GRADE CURRICULAR',
                      description:
                          'Selecione um curso e veja as disciplinas distribuídas por período.',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const GradeCurricularPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomCard(
                      title: 'REMATRÍCULA ONLINE',
                      description:
                          'Fazer a rematrícula nos semestres posteriores, conforme '
                          'calendário acadêmico. Emissão da declaração de vínculo.',
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.disciplinaForm);
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomCard(
                      title: 'SITUAÇÃO ACADÊMICA',
                      description:
                          'Veja a sua situação junto a secretaria e demais departamentos '
                          'da unitins.',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    CustomCard(
                      title: 'ANÁLISE CURRICULAR',
                      description: 'Análise curricular completa.',
                      onPressed: () {},
                    ),
                    // const SizedBox(height: 30),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     const Text(
                    //       'ÚLTIMA NOTÍCIA',
                    //       style: TextStyle(
                    //         fontFamily: 'OpenSans',
                    //         fontSize: 20,
                    //         color: Color(0xFF094AB2),
                    //         fontWeight: FontWeight.w300,
                    //       ),
                    //     ),
                    //     Icon(Icons.add_sharp, color: Color(0xFF003F92)),
                    //   ],
                    // ),
                    // const SizedBox(height: 8),
                    // const Divider(color: Colors.grey, thickness: 1),
                    // const SizedBox(height: 30),
                    // const Text(
                    //   'Unitins celebra 35 anos com expansão e \nimpacto na educação do '
                    //   'Tocantins',
                    //   style: TextStyle(
                    //     fontFamily: 'OpenSans',
                    //     fontSize: 20,
                    //     color: Color(0xFF094AB2),
                    //     fontWeight: FontWeight.w300,
                    //   ),
                    // ),
                    // const SizedBox(height: 12),
                    // const Text(
                    //   'São mais de três décadas marcadas por conquistas e transformações'
                    //   ' que consolidam sua presença no Tocantins',
                    //   style: TextStyle(
                    //     fontFamily: 'OpenSans',
                    //     fontSize: 18,
                    //     color: Color(0xFF094AB2),
                    //     fontWeight: FontWeight.w300,
                    //   ),
                    // ),
                    // const SizedBox(height: 12),
                    // Image.network(
                    //   'https://www.unitins.br/cms/Midia/Imagens/GNNBVJODDKD4O696UBLWSUTASRWJVSU4PP4ZZBA8.png',
                    //   fit: BoxFit.cover,
                    //   width: double.infinity,
                    // ),
                  ],
                ),
              ),
              const CustomFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
