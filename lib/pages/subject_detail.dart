import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../tools/request_parser.dart';
import '../entries/subject.dart';
import '../entries/label.dart';

class SubjectDetailPage extends StatefulWidget {
  final int subjectId;

  SubjectDetailPage(this.subjectId);

  @override
  State<StatefulWidget> createState() {
    return new _SubjectDetailPageState();
  }
}

class _SubjectDetailPageState extends State<SubjectDetailPage> {
  Subject _subject;

  @override
  void initState() {
    super.initState();
    _getSubjectDetail();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            expandedHeight: 256.0,
            pinned: true,
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  print('Edit preesed');
                },
                tooltip: 'Improve',
              )
            ],
            flexibleSpace: new FlexibleSpaceBar(
              title: const Text('Subject Detail'),
              background: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new FadeInImage(
                    placeholder: AssetImage('assets/subject_placeholder.png'),
                    image: AssetImage('assets/subject_placeholder.png'),
                    fit: BoxFit.cover,
                    height: 256.0,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, -0.4),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new SliverList(
              delegate: new SliverChildListDelegate(<Widget>[
            new Container(
              padding: const EdgeInsets.all(8.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildContent(),
              ),
            ),
          ]))
        ],
      ),
    );
  }

  void _getSubjectDetail() {
    RequestParser.getSubjectDetail("/subject/findById",
        params: {'subject_id': widget.subjectId}).then((result) {
      if (result is Subject) {
        _subject = result;
        setState(() {});
      }
    });
  }

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return new HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  Widget _buildLabels() {
    if (_subject == null) {
      return null;
    }
//    else {
//      if (_subject.labels == null) {
//        _subject.labels = new List<Label>();
//      }
//      _subject.labels.add(new Label("+", "+"));
//    }
    return new Wrap(
      children: _subject.labels.map<Widget>((Label labe) {
        return new Padding(
          padding: const EdgeInsets.all(2.0),
          child: new Chip(
            key: new ValueKey<String>(labe.nameEN),
            backgroundColor: _nameToColor(labe.nameCN),
            label: new Text(labe.nameEN),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildContent() {
    if (_subject == null) {
      return <Widget>[
        new Center(
          child: new Text('Waiting for loading...'),
        )
      ];
    } else {
      List<Widget> content = <Widget>[
        new Text(_subject.title,
            style: new TextStyle(
                color: const Color(0xff283593),
                fontSize: 24.0,
                fontStyle: FontStyle.italic)),
        const SizedBox(height: 8.0),
        new Container(
          alignment: Alignment.centerLeft,
          child: _buildLabels(),
        ),
        new Text(
          _subject.updateDate.toString(),
          textAlign: TextAlign.right,
          style: new TextStyle(color: const Color(0xff9fa8da)),
        ),
        const SizedBox(height: 8.0),
        new Text(
          '    ${_subject.content}',
          style: new TextStyle(fontSize: 16.0, color: const Color(0xff1a237e)),
        )
      ];
      if (_subject != null &&
          _subject.operateSteps != null &&
          _subject.operateSteps.isNotEmpty) {
        content.addAll(_buildOperateSteps());
      }
      return content;
    }
  }

  List<Widget> _buildOperateSteps() {
    List<Widget> stepsOperates = <Widget>[
      const SizedBox(height: 8.0),
      const Divider(height: 1.0, color: const Color(0xff9fa8da)),
      const SizedBox(height: 8.0),
      const Text('Operate Steps: ',
          style: const TextStyle(
              color: const Color(0xff283593),
              fontSize: 18.0,
              fontStyle: FontStyle.italic)),
      const SizedBox(height: 4.0)
    ];
    _subject.operateSteps.forEach((Steps steps) {
      stepsOperates.add(new Text(steps.operation));
      stepsOperates.add(new Text(steps.timeCosts.toString()));
      stepsOperates.add(new Text(steps.picture));
      stepsOperates.add(const SizedBox(height: 2.0));
    });
    return stepsOperates;
  }
}
