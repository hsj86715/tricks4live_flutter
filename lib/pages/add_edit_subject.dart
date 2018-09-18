import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../tools/request_parser.dart';
import '../entries/subject.dart';
import '../entries/label.dart';

enum ContentType { simple, step, stepWithTime }

class SubjectEditPage extends StatefulWidget {
  Subject _subjectInfo;

  SubjectEditPage({Subject subjectInfo}) {
    if (subjectInfo == null) {
      this._subjectInfo = new Subject();
    } else {
      this._subjectInfo = subjectInfo;
    }
  }

  @override
  State<StatefulWidget> createState() {
    return new _SubjectEditPageState();
  }
}

class _SubjectEditPageState extends State<SubjectEditPage> {
  bool _autovalidate = false;
  bool _formWasEdited = false;

  ContentType _contentType = ContentType.step;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Edit'),
        actions: <Widget>[
          new IconButton(
              icon: new SvgPicture.asset("assets/icons/ic_save.svg",
                  width: 28.0, height: 28.0),
              onPressed: () {}),
          new PopupMenuButton<ContentType>(
              onSelected: _changeContentType,
              itemBuilder: (context) {
                return <PopupMenuItem<ContentType>>[
                  const PopupMenuItem<ContentType>(
                      value: ContentType.simple, child: Text('Simple')),
                  const PopupMenuItem<ContentType>(
                      value: ContentType.step, child: Text('Step')),
                  const PopupMenuItem<ContentType>(
                      value: ContentType.stepWithTime,
                      child: Text('Step With Time'))
                ];
              })
        ],
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              autovalidate: _autovalidate,
              child: new SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildContent(),
                ),
              ))),
    );
  }

  List<Widget> _buildContent() {
    List<Widget> contents = <Widget>[
      const SizedBox(height: 8.0),
      new TextFormField(
          textCapitalization: TextCapitalization.words,
          autofocus: true,
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              labelText: "Title *",
              hintText: 'Title of subject.'),
          onSaved: (String title) {
            widget._subjectInfo.title = title;
          },
          validator: _validateTitle,
          maxLength: 128),
      const SizedBox(height: 8.0),
      new TextFormField(
          textCapitalization: TextCapitalization.words,
          autofocus: false,
          maxLines: 10,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              labelText: "Content *",
              hintText: 'Content of the subject.'),
          onSaved: (String content) {
            widget._subjectInfo.content = content;
          },
          validator: _validateContent,
          maxLength: 4096),
    ];

    contents.addAll(_buildOperateSteps());

    return contents;
  }

  void _changeContentType(ContentType type) {
    setState(() {
      _contentType = type;
    });
  }

  String _validateTitle(String title) {
    _formWasEdited = true;
    if (title.isEmpty) return 'Subject title is required.';
    return null;
  }

  String _validateContent(String content) {
    _formWasEdited = true;
    if (content.isEmpty) return 'Subject content is required.';
    return null;
  }

  List<Widget> _buildOperateSteps() {
    if (_contentType == ContentType.simple) {
      return <Widget>[const SizedBox(height: 0.0)];
    } else {
      List<Widget> operateSteps = <Widget>[
        const SizedBox(height: 16.0),
        const Text('Operate Steps',
            style: const TextStyle(
                color: const Color(0xff283593),
                fontSize: 18.0,
                fontStyle: FontStyle.italic)),
        new ListView.builder(
          itemCount: 3,
          itemBuilder: (context, i) {
            return __buildStepItem(i);
          },
        ),
        new Center(
          child: new FlatButton(onPressed: () {}, child: const Icon(Icons.add)),
        )
      ];
      return operateSteps;
    }
  }

  Widget __buildStepItem(i) {
    return new Wrap(
      children: <Widget>[
        const SizedBox(height: 8.0),
        new TextFormField(
            textCapitalization: TextCapitalization.words,
            autofocus: true,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                labelText: "Operate *",
                hintText: 'Operate of current step.'),
            onSaved: (String operation) {
//            widget._steps.operation = operation;
            },
//          validator: _validateTitle,
            maxLength: 512),
        const SizedBox(height: 4.0),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new TextFormField(
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    labelText: "Picture",
                    hintText: 'Operate of current step.'),
                onSaved: (String operation) {
//                widget._steps.operation = operation;
                },
//          validator: _validateTitle,
                maxLength: 512),
            new FlatButton(onPressed: () {}, child: new Text('...'))
          ],
        ),
        const SizedBox(height: 4.0),
        new TextFormField(
            textCapitalization: TextCapitalization.words,
            autofocus: true,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                labelText: "Time cost",
                hintText: 'Time cost of current step.'),
            onSaved: (String operation) {
//            widget._steps.operation = operation;
            },
//          validator: _validateTitle,
            maxLength: 512),
      ],
    );
  }
}
