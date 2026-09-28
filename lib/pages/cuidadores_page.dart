import 'package:flutter/material.dart';

import '../styles/appbar_styles.dart';
import '../styles/drawer_styles.dart';
import 'detalhes_cuidador_page.dart';

class CuidadoresPage extends StatefulWidget {
  const CuidadoresPage({super.key});

  @override
  State<CuidadoresPage> createState() => _CuidadoresPageState();
}

class _CuidadoresPageState extends State<CuidadoresPage> {
  final List<Map<String, dynamic>> cuidadores = [
    {
      'nome': 'Ana Silva',
      'profissao': 'Passeadora e cuidadora',
      'avaliacao': 4.9,
      'distancia': 0.8,
      'inicial': 'A',
      'servicos': ['Passeio', 'Hospedagem'],
      'experiencia': '4 anos de experiência com cães e gatos.',
      'disponibilidade': 'Segunda a sábado',
    },
    {
      'nome': 'Carlos Santos',
      'profissao': 'Cuidador de pets',
      'avaliacao': 4.8,
      'distancia': 1.2,
      'inicial': 'C',
      'servicos': ['Hospedagem', 'Passeio'],
      'experiencia': 'Especialista em cuidados durante viagens.',
      'disponibilidade': 'Todos os dias',
    },
    {
      'nome': 'Mariana Oliveira',
      'profissao': 'Passeadora',
      'avaliacao': 5.0,
      'distancia': 1.5,
      'inicial': 'M',
      'servicos': ['Passeio'],
      'experiencia': 'Passeios individuais para cães.',
      'disponibilidade': 'Segunda a sexta',
    },
    {
      'nome': 'João Pereira',
      'profissao': 'Cuidador e hospedagem',
      'avaliacao': 4.7,
      'distancia': 2.0,
      'inicial': 'J',
      'servicos': ['Hospedagem', 'Banho e tosa'],
      'experiencia': 'Experiência com cães de pequeno e médio porte.',
      'disponibilidade': 'Finais de semana',
    },
    {
      'nome': 'Beatriz Costa',
      'profissao': 'Banho, tosa e cuidados',
      'avaliacao': 4.9,
      'distancia': 2.4,
      'inicial': 'B',
      'servicos': ['Banho e tosa'],
      'experiencia': 'Cuidados de higiene e bem-estar dos pets.',
      'disponibilidade': 'Terça a sábado',
    },
    {
      'nome': 'Lucas Almeida',
      'profissao': 'Passeador de cães',
      'avaliacao': 4.6,
      'distancia': 2.8,
      'inicial': 'L',
      'servicos': ['Passeio', 'Banho e tosa'],
      'experiencia': 'Passeios e atividades para cães.',
      'disponibilidade': 'Segunda a domingo',
    },
  ];

  List<Map<String, dynamic>> cuidadoresFiltrados = [];

  final List<Map<String, dynamic>> agendamentos = [];

  String filtroAtual = 'Todos';

  @override
  void initState() {
    super.initState();
    cuidadoresFiltrados = List.from(cuidadores);
  }

  void aplicarFiltro(String filtro) {
    setState(() {
      filtroAtual = filtro;

      if (filtro == 'Mais próximos') {
        cuidadoresFiltrados = List.from(cuidadores)
          ..sort(
                (a, b) => (a['distancia'] as double)
                .compareTo(b['distancia'] as double),
          );
      } else if (filtro == 'Melhor avaliados') {
        cuidadoresFiltrados = List.from(cuidadores)
          ..sort(
                (a, b) => (b['avaliacao'] as double)
                .compareTo(a['avaliacao'] as double),
          );
      } else if (filtro == 'Passeio') {
        cuidadoresFiltrados = cuidadores
            .where((cuidador) =>
            (cuidador['servicos'] as List).contains('Passeio'))
            .toList();
      } else if (filtro == 'Hospedagem') {
        cuidadoresFiltrados = cuidadores
            .where((cuidador) =>
            (cuidador['servicos'] as List).contains('Hospedagem'))
            .toList();
      } else if (filtro == 'Banho e tosa') {
        cuidadoresFiltrados = cuidadores
            .where((cuidador) =>
            (cuidador['servicos'] as List).contains('Banho e tosa'))
            .toList();
      } else {
        cuidadoresFiltrados = List.from(cuidadores);
      }
    });
  }

  Future<void> abrirDetalhes(Map<String, dynamic> cuidador) async {
    final temAgendamento = agendamentos.any(
          (agendamento) => agendamento['cuidador'] == cuidador['nome'],
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesCuidadorPage(
          nome: cuidador['nome'],
          profissao: cuidador['profissao'],
          avaliacao: cuidador['avaliacao'],
          distancia: cuidador['distancia'],
          inicial: cuidador['inicial'],
          servicos: cuidador['servicos'],
          experiencia: cuidador['experiencia'],
          disponibilidade: cuidador['disponibilidade'],
          temAgendamento: temAgendamento,
          onAgendamentoCriado: (novoAgendamento) {
            setState(() {
              agendamentos.removeWhere(
                    (agendamento) =>
                agendamento['cuidador'] == novoAgendamento['cuidador'],
              );

              agendamentos.add(novoAgendamento);
            });
          },
          onAgendamentoCancelado: () {
            setState(() {
              agendamentos.removeWhere(
                    (agendamento) =>
                agendamento['cuidador'] == cuidador['nome'],
              );
            });
          },
        ),
      ),
    );
  }

  void mostrarMeusAgendamentos() {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: AppBarStyles.corFundo,
              ),
              SizedBox(width: 10),
              Text('Meus agendamentos'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: agendamentos.isEmpty
                ? const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 60,
                  color: Colors.grey,
                ),
                SizedBox(height: 15),
                Text(
                  'Você ainda não possui agendamentos.',
                  textAlign: TextAlign.center,
                ),
              ],
            )
                : ListView.builder(
              shrinkWrap: true,
              itemCount: agendamentos.length,
              itemBuilder: (context, index) {
                final agendamento = agendamentos[index];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agendamento['cuidador'],
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Serviço: ${agendamento['servico']}',
                        ),
                        Text(
                          'Data: ${agendamento['data']}',
                        ),
                        Text(
                          'Horário: ${agendamento['horario']}',
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                _cancelarAgendamento(
                                  agendamento['cuidador'],
                                );
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _cancelarAgendamento(String nomeCuidador) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancelar agendamento?'),
          content: Text(
            'Tem certeza que deseja cancelar o agendamento com $nomeCuidador?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Não',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  agendamentos.removeWhere(
                        (agendamento) =>
                    agendamento['cuidador'] == nomeCuidador,
                  );
                });

                Navigator.pop(context);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Agendamento cancelado.'),
                  ),
                );
              },
              child: const Text(
                'Sim, cancelar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void mostrarConfiguracoes() {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) {
        bool notificacoes = true;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Configurações'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    child: Icon(
                      Icons.person,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Minha conta',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Nome'),
                    subtitle: Text('Erick Tainer'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Telefone'),
                    subtitle: Text('(11) 99999-9999'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.email),
                    title: Text('E-mail'),
                    subtitle: Text('erick@email.com'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.badge),
                    title: Text('CPF'),
                    subtitle: Text('000.000.000-00'),
                  ),
                  SwitchListTile(
                    value: notificacoes,
                    title: const Text('Notificações'),
                    secondary: const Icon(Icons.notifications),
                    onChanged: (valor) {
                      setDialogState(() {
                        notificacoes = valor;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget criarDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: DrawerStyles.corCabecalho,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.pets,
                  size: 50,
                  color: DrawerStyles.corTextoCabecalho,
                ),
                const SizedBox(height: 8),
                Text(
                  'AmigoPet',
                  style: TextStyle(
                    color: DrawerStyles.corTextoCabecalho,
                    fontSize: DrawerStyles.tamanhoTitulo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.pets,
              color: DrawerStyles.corIcone,
            ),
            title: const Text(
              'Cuidadores',
              style: TextStyle(
                fontSize: DrawerStyles.tamanhoOpcao,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.calendar_month,
              color: DrawerStyles.corIcone,
            ),
            title: const Text(
              'Meus agendamentos',
              style: TextStyle(
                fontSize: DrawerStyles.tamanhoOpcao,
              ),
            ),
            onTap: mostrarMeusAgendamentos,
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: DrawerStyles.corIcone,
            ),
            title: const Text(
              'Configurações',
              style: TextStyle(
                fontSize: DrawerStyles.tamanhoOpcao,
              ),
            ),
            onTap: mostrarConfiguracoes,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: criarDrawer(),
      appBar: AppBar(
        backgroundColor: AppBarStyles.corFundo,
        foregroundColor: AppBarStyles.corTexto,
        elevation: AppBarStyles.elevacao,
        centerTitle: true,
        title: const Text(
          'AmigoPet',
          style: TextStyle(
            fontSize: AppBarStyles.tamanhoTitulo,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: aplicarFiltro,
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: 'Todos',
                  child: Text('Todos'),
                ),
                PopupMenuItem(
                  value: 'Mais próximos',
                  child: Text('Mais próximos'),
                ),
                PopupMenuItem(
                  value: 'Melhor avaliados',
                  child: Text('Melhor avaliados'),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 'Passeio',
                  child: Text('Passeio'),
                ),
                PopupMenuItem(
                  value: 'Hospedagem',
                  child: Text('Hospedagem'),
                ),
                PopupMenuItem(
                  value: 'Banho e tosa',
                  child: Text('Banho e tosa'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            color: Colors.green.withOpacity(0.08),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppBarStyles.corFundo,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    filtroAtual == 'Todos'
                        ? 'Cuidadores próximos de você'
                        : 'Filtro: $filtroAtual',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${cuidadoresFiltrados.length} encontrados',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cuidadoresFiltrados.length,
              itemBuilder: (context, index) {
                final cuidador = cuidadoresFiltrados[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(5),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: AppBarStyles.corFundo,
                        child: Text(
                          cuidador['inicial'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        cuidador['nome'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(cuidador['profissao']),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              Text(
                                ' ${cuidador['avaliacao']}',
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.location_on,
                                size: 17,
                                color: Colors.grey,
                              ),
                              Text(
                                ' ${cuidador['distancia']} km',
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                      onTap: () => abrirDetalhes(cuidador),
                    ),
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