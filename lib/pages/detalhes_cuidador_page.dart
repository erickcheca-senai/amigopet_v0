import 'package:flutter/material.dart';

import '../styles/appbar_styles.dart';
import '../styles/alertdialog_styles.dart';
import '../styles/simpledialog_styles.dart';
import '../styles/bottomsheet_styles.dart';

class DetalhesCuidadorPage extends StatefulWidget {
  final String nome;
  final String profissao;
  final double avaliacao;
  final double distancia;
  final String inicial;
  final List<String> servicos;
  final String experiencia;
  final String disponibilidade;

  final bool temAgendamento;

  final Function(Map<String, dynamic>) onAgendamentoCriado;
  final VoidCallback onAgendamentoCancelado;

  const DetalhesCuidadorPage({
    super.key,
    required this.nome,
    required this.profissao,
    required this.avaliacao,
    required this.distancia,
    required this.inicial,
    required this.servicos,
    required this.experiencia,
    required this.disponibilidade,
    required this.temAgendamento,
    required this.onAgendamentoCriado,
    required this.onAgendamentoCancelado,
  });

  @override
  State<DetalhesCuidadorPage> createState() =>
      _DetalhesCuidadorPageState();
}

class _DetalhesCuidadorPageState
    extends State<DetalhesCuidadorPage> {
  late bool agendado;

  String? servicoEscolhido;
  DateTime? dataEscolhida;
  TimeOfDay? horarioEscolhido;

  @override
  void initState() {
    super.initState();
    agendado = widget.temAgendamento;
  }

  Future<void> escolherServico() async {
    final String? servico = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            'Tipo de serviço',
            style: TextStyle(
              fontSize: SimpleDialogStyles.tamanhoTitulo,
            ),
          ),
          children: [
            if (widget.servicos.contains('Passeio'))
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'Passeio');
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.directions_walk,
                      color: SimpleDialogStyles.corIcone,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Passeio',
                      style: TextStyle(
                        fontSize: SimpleDialogStyles.tamanhoOpcao,
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.servicos.contains('Hospedagem'))
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'Hospedagem');
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.home,
                      color: SimpleDialogStyles.corIcone,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Hospedagem',
                      style: TextStyle(
                        fontSize: SimpleDialogStyles.tamanhoOpcao,
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.servicos.contains('Banho e tosa'))
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'Banho e tosa');
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.shower,
                      color: SimpleDialogStyles.corIcone,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Banho e tosa',
                      style: TextStyle(
                        fontSize: SimpleDialogStyles.tamanhoOpcao,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );

    if (servico != null) {
      setState(() {
        servicoEscolhido = servico;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Serviço selecionado: $servico'),
        ),
      );
    }
  }

  Future<void> escolherData() async {
    final DateTime hoje = DateTime.now();

    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: hoje,
      lastDate: DateTime(
        hoje.year + 1,
        hoje.month,
        hoje.day,
      ),
    );

    if (data != null) {
      setState(() {
        dataEscolhida = data;
      });
    }
  }

  Future<void> escolherHorario() async {
    final TimeOfDay? horario = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horario != null) {
      setState(() {
        horarioEscolhido = horario;
      });
    }
  }

  String formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString();

    return '$dia/$mes/$ano';
  }

  String formatarHorario(TimeOfDay horario) {
    final hora = horario.hour.toString().padLeft(2, '0');
    final minuto = horario.minute.toString().padLeft(2, '0');

    return '$hora:$minuto';
  }

  Future<void> agendar() async {
    if (servicoEscolhido == null) {
      await escolherServico();

      if (servicoEscolhido == null) {
        return;
      }
    }

    await escolherData();

    if (dataEscolhida == null) {
      return;
    }

    await escolherHorario();

    if (horarioEscolhido == null) {
      return;
    }

    final novoAgendamento = {
      'cuidador': widget.nome,
      'servico': servicoEscolhido!,
      'data': formatarData(dataEscolhida!),
      'horario': formatarHorario(horarioEscolhido!),
    };

    widget.onAgendamentoCriado(novoAgendamento);

    setState(() {
      agendado = true;
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Agendamento confirmado com sucesso!',
        ),
      ),
    );
  }

  void cancelarAgendamento() {
    if (!agendado) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Nenhum agendamento',
              style: TextStyle(
                fontSize: AlertDialogStyles.tamanhoTitulo,
              ),
            ),
            content: Text(
              'Você ainda não possui um agendamento com este cuidador.',
              style: TextStyle(
                fontSize: AlertDialogStyles.tamanhoMensagem,
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

      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Cancelar agendamento?',
            style: TextStyle(
              fontSize: AlertDialogStyles.tamanhoTitulo,
            ),
          ),
          content: Text(
            'Tem certeza que deseja cancelar o agendamento com ${widget.nome}?',
            style: TextStyle(
              fontSize: AlertDialogStyles.tamanhoMensagem,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Não',
                style: TextStyle(
                  color: AlertDialogStyles.corBotao,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  agendado = false;
                });

                widget.onAgendamentoCancelado();

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Agendamento cancelado.',
                    ),
                  ),
                );
              },
              child: Text(
                'Sim, cancelar',
                style: TextStyle(
                  color: AlertDialogStyles.corCancelar,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void mostrarSobreCuidador() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Sobre ${widget.nome}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.pets,
                  size: 55,
                  color: AppBarStyles.corFundo,
                ),
                const SizedBox(height: 15),
                Text(
                  widget.experiencia,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Disponibilidade:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.disponibilidade),
                const SizedBox(height: 15),
                const Text(
                  'Serviços oferecidos:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                ...widget.servicos.map(
                      (servico) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• $servico'),
                  ),
                ),
              ],
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

  void compartilharPerfil() {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Compartilhar perfil'),
          content: Text(
            'Perfil de ${widget.nome} pronto para ser compartilhado.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Perfil compartilhado!',
                    ),
                  ),
                );
              },
              child: const Text('Compartilhar'),
            ),
          ],
        );
      },
    );
  }

  void denunciarCuidador() {
    Navigator.pop(context);

    String motivo = 'Maus-tratos aos animais';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Denunciar cuidador'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Qual é o motivo da denúncia?',
                  ),
                  const SizedBox(height: 10),
                  RadioListTile<String>(
                    title: const Text('Maus-tratos aos animais'),
                    value: 'Maus-tratos aos animais',
                    groupValue: motivo,
                    onChanged: (valor) {
                      setDialogState(() {
                        motivo = valor!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Comportamento inadequado'),
                    value: 'Comportamento inadequado',
                    groupValue: motivo,
                    onChanged: (valor) {
                      setDialogState(() {
                        motivo = valor!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Informações falsas'),
                    value: 'Informações falsas',
                    groupValue: motivo,
                    onChanged: (valor) {
                      setDialogState(() {
                        motivo = valor!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Cobrança indevida'),
                    value: 'Cobrança indevida',
                    groupValue: motivo,
                    onChanged: (valor) {
                      setDialogState(() {
                        motivo = valor!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Outro motivo'),
                    value: 'Outro motivo',
                    groupValue: motivo,
                    onChanged: (valor) {
                      setDialogState(() {
                        motivo = valor!;
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
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Denúncia enviada: $motivo',
                        ),
                      ),
                    );
                  },
                  child: const Text('Enviar denúncia'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void maisOpcoes() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(
              BottomSheetStyles.espacamento,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Mais opções',
                    style: TextStyle(
                      fontSize: BottomSheetStyles.tamanhoTitulo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: BottomSheetStyles.corIcone,
                  ),
                  title: const Text(
                    'Sobre o cuidador',
                    style: TextStyle(
                      fontSize: BottomSheetStyles.tamanhoOpcao,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    mostrarSobreCuidador();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.share,
                    color: BottomSheetStyles.corIcone,
                  ),
                  title: const Text(
                    'Compartilhar perfil',
                    style: TextStyle(
                      fontSize: BottomSheetStyles.tamanhoOpcao,
                    ),
                  ),
                  onTap: compartilharPerfil,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Denunciar cuidador',
                    style: TextStyle(
                      fontSize: BottomSheetStyles.tamanhoOpcao,
                    ),
                  ),
                  onTap: denunciarCuidador,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarStyles.corFundo,
        foregroundColor: AppBarStyles.corTexto,
        elevation: AppBarStyles.elevacao,
        centerTitle: true,
        title: Text(
          widget.nome,
          style: const TextStyle(
            fontSize: AppBarStyles.tamanhoTitulo,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: maisOpcoes,
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: AppBarStyles.corFundo,
              child: Text(
                widget.inicial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.nome,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.profissao,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                Text(
                  ' ${widget.avaliacao}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(
                  Icons.location_on,
                  color: Colors.grey,
                ),
                Text(
                  ' ${widget.distancia} km',
                ),
              ],
            ),
            const SizedBox(height: 25),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Serviços disponíveis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...widget.servicos.map(
                          (servico) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.check_circle,
                          color: AppBarStyles.corFundo,
                        ),
                        title: Text(servico),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.info,
                  color: AppBarStyles.corFundo,
                ),
                title: const Text(
                  'Experiência',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(widget.experiencia),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.access_time,
                  color: AppBarStyles.corFundo,
                ),
                title: const Text(
                  'Disponibilidade',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(widget.disponibilidade),
              ),
            ),
            const SizedBox(height: 25),

            // BOTÃO TIPO DE SERVIÇO
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: escolherServico,
                icon: const Icon(Icons.pets),
                label: Text(
                  servicoEscolhido == null
                      ? 'Tipo de serviço'
                      : 'Serviço: $servicoEscolhido',
                ),
              ),
            ),

            const SizedBox(height: 10),

            // BOTÃO AGENDAR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: agendar,
                icon: const Icon(Icons.calendar_month),
                label: Text(
                  agendado
                      ? 'Agendamento confirmado'
                      : 'Agendar',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppBarStyles.corFundo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // BOTÃO CANCELAR
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: cancelarAgendamento,
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                label: const Text(
                  'Cancelar agendamento',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // BOTÃO MAIS OPÇÕES
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: maisOpcoes,
                icon: const Icon(Icons.more_horiz),
                label: const Text('Mais opções'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}