import 'package:flutter/material.dart';

import '../components/custom_card.dart';

class UnitinsAppsPage extends StatefulWidget {
  const UnitinsAppsPage({super.key});

  @override
  State<UnitinsAppsPage> createState() => _UnitinsAppsPageState();
}

class _UnitinsAppsPageState extends State<UnitinsAppsPage>
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
          height: 50,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black54),
            onPressed: () {},
          ),
        ],
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aplicativos',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              color: Color(0xFF094AB2),
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'CENTRAL DE APLICATIVOS UNITINS',
            description: 'Central de Aplicativos.',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'BIBLIOTECA ONLINE',
            description:
                'Sistema da biblioteca para reserva e\nrenovação de livros.',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'BIBLIOTECA VIRTUAL',
            description:
                'Sistema de acesso ao acerto virtual das \nbibliotecas.',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'CADUN - CADASTRO ÚNICO DE \nUSUÁRIOS',
            description: 'Gestão de Usuário.',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'EDUC@ PRESENCIAL',
            description:
                'Educ@ Presencial - Sistema destinado a \nprofessores e alunos.',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'INFORME DE RENDIMENTOS \n(CÉDULA C)',
            description: 'Acesso aos comprovantes de \nrendimentos.',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'I-PROTOCOLO',
            description:
                'Este é um local onde você poderá enviar \npara a UNITINS sua '
                'solicitação de \nserviços.',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'QUESTIONÁRIO (CPA)',
            description:
                'Sistema de Questionários Institucionais e \npara CPA.',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'SIPP',
            description:
                'Sistema de Institucionalização de \nProjetos de Pesquisa.',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'VOTAÇÃO DIGITAL',
            description: 'Sistema de Votação Digital.',
            onPressed: () {},
          ),
          const SizedBox(height: 30),
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
            description: 'Desempenho nas disciplinas do \nsemestre atual.',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'GRADE CURRICULAR',
            description:
                'Selecione um curso e veja as disciplinas \ndistribuídas por período.',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'REMATRÍCULA ONLINE',
            description:
                'Fazer a rematrícula nos semestres \nposteriores, conforme '
                'calendário \nacadêmico. Emissão da declaração de \nvínculo.',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'SITUAÇÃO ACADÊMICA',
            description:
                'Veja a sua situação junto a secretaria \ne demais departamentos '
                'da unitins.',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'BOLETIM (SEMESTRE ATUAL)',
            description: 'Desempenho nas disciplinas do \nsemestre atual.',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          CustomCard(
            title: 'ANÁLISE CURRICULAR',
            description: 'Análise curricular completa.',
            onPressed: () {},
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ÚLTIMA NOTÍCIA',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  color: Color(0xFF094AB2),
                  fontWeight: FontWeight.w300,
                ),
              ),
              Icon(Icons.add_sharp, color: Color(0xFF003F92)),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'Unitins celebra 35 anos com expansão e \nimpacto na educação do '
            'Tocantins',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              color: Color(0xFF094AB2),
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'São mais de três décadas marcadas por conquistas e \ntransformações'
                ' que consolidam sua presença no Tocantins',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              color: Color(0xFF094AB2),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
