import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../tools/request_parser.dart';
import '../entries/subject.dart';
import '../entries/label.dart';

enum ContentType { simple, step, stepWithTime }

class SubjectEditPage extends StatefulWidget {
  Subject subjectInfo;

  SubjectEditPage({this.subjectInfo}) {
    if (subjectInfo == null) {
      subjectInfo = new Subject();
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _SubjectEditPageState();
  }
}

class _SubjectEditPageState extends State<SubjectEditPage> {
  bool _autovalidate = false;
  bool _formWasEdited = false;
  int _stepCount = 3;

  ContentType _contentType = ContentType.step;

  @override
  void initState() {
    if (widget.subjectInfo.operateSteps != null &&
        widget.subjectInfo.operateSteps.isNotEmpty) {
      _stepCount = widget.subjectInfo.operateSteps.length;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Edit'), actions: <Widget>[
          IconButton(
              icon: SvgPicture.asset("assets/icons/ic_save.svg",
                  width: 28.0, height: 28.0),
              onPressed: () {}),
          PopupMenuButton<ContentType>(
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
        ]),
        body: SafeArea(
            top: false,
            bottom: false,
            child: Form(
                autovalidate: _autovalidate,
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _buildContent())))));
  }

  List<Widget> _buildContent() {
    List<Widget> contents = <Widget>[
      const SizedBox(height: 8.0),
      TextFormField(
          initialValue: widget.subjectInfo.title,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              labelText: "Title *",
              hintText: 'Title of subject.'),
          onSaved: (String title) {
            widget.subjectInfo.title = title;
          },
          validator: _validateTitle,
          maxLength: 128),
      const SizedBox(height: 8.0),
      _buildLabels(),
      const SizedBox(height: 8.0),
      GestureDetector(
          child: Image(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 2 / 3,
              fit: BoxFit.fill,
              image: widget.subjectInfo.coverPicture == null
                  ? AssetImage("assets/subject_placeholder.png")
                  : widget.subjectInfo.coverPicture.startsWith('http')
                      ? NetworkImage(widget.subjectInfo.coverPicture)
                      : FileImage(File(widget.subjectInfo.coverPicture)))),
      const SizedBox(height: 8.0),
      TextFormField(
          initialValue: widget.subjectInfo.content,
          textCapitalization: TextCapitalization.words,
          maxLines: 10,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              labelText: "Content *",
              hintText: 'Content of the subject.'),
          onSaved: (String content) {
            widget.subjectInfo.content = content;
          },
          validator: _validateContent,
          maxLength: 4096),
//      Row(children: <Widget>[
//        Expanded(
//            child: TextFormField(
//          initialValue: widget.subjectInfo.coverPicture,
//          decoration: const InputDecoration(
//              border: UnderlineInputBorder(),
//              filled: true,
//              labelText: "Picture",
//              hintText: 'Cover picture.'),
//          onSaved: (String operation) {
////                widget._steps.operation = operation;
//          },
////          validator: _validateTitle
//        )),
//        FlatButton(
//            padding: EdgeInsets.all(8.0),
//            onPressed: () {},
//            child: Icon(Icons.image, color: Colors.blueAccent))
//      ])
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

  Color _nameToColor(String name) {
    assert(name.length >= 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  ///创建标签
  Widget _buildLabels() {
    List<Widget> labelWidgets =
        widget.subjectInfo.labels.map<Widget>((Label labe) {
      return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Chip(
              key: ValueKey<String>(labe.nameEN),
              backgroundColor: _nameToColor(labe.nameCN),
              label: Text(Localizations.localeOf(context).languageCode == 'en'
                  ? labe.nameEN
                  : labe.nameCN)));
    }).toList();
    labelWidgets.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: Chip(
            key: ValueKey<String>("Add"),
            backgroundColor: _nameToColor("添加"),
            label: Icon(Icons.add, size: 24.0, color: Colors.white))));
    return Wrap(children: labelWidgets);
  }

  ///创建操作步骤
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
                fontStyle: FontStyle.italic))
      ];
      for (int i = 0; i < _stepCount; i++) {
        operateSteps.add(__buildStepItem(i));
      }
      operateSteps.add(Center(
          child: FlatButton(
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                _stepCount++;
                setState(() {});
              },
              child: const Icon(Icons.add,
                  size: 48.0, color: Colors.greenAccent))));
      return operateSteps;
    }
  }

  Widget __buildStepItem(index) {
    List<Widget> stepItem = <Widget>[
      const SizedBox(height: 8.0),
      //这里将插入步骤抬头
      const SizedBox(height: 4.0),
      TextFormField(
          initialValue: widget.subjectInfo.operateSteps != null &&
                  index < widget.subjectInfo.operateSteps.length
              ? widget.subjectInfo.operateSteps[index].operation
              : '',
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              labelText: "Operate  *",
              hintText: 'Operate of current step.'),
          onSaved: (String operation) {
//            widget._steps.operation = operation;
          },
//          validator: _validateTitle,
          maxLength: 512),
      const SizedBox(height: 4.0),
      Row(children: <Widget>[
        Expanded(
            child: TextFormField(
          initialValue: widget.subjectInfo.operateSteps != null &&
                  index < widget.subjectInfo.operateSteps.length
              ? widget.subjectInfo.operateSteps[index].picture
              : '',
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              labelText: "Picture",
              hintText: 'Operate effect of current step.'),
          onSaved: (String operation) {
//                widget._steps.operation = operation;
          },
//          validator: _validateTitle
        )),
        FlatButton(
            padding: EdgeInsets.all(8.0),
            onPressed: () {},
            child: Icon(Icons.image, color: Colors.blueAccent))
      ])
    ];
    if (index == _stepCount - 1 && _stepCount > 1) {
      stepItem.insert(
          1,
          Row(children: <Widget>[
            Expanded(
                child: Text("Step ${index + 1} :",
                    style: TextStyle(fontSize: 16.0))),
            GestureDetector(
                onTap: () {
                  _stepCount--;
                  setState(() {});
                },
                child:
                    const Icon(Icons.delete_forever, color: Colors.redAccent))
          ]));
    } else {
      stepItem.insert(
          1, Text("Step ${index + 1} :", style: TextStyle(fontSize: 16.0)));
    }

    if (_contentType == ContentType.stepWithTime) {
      stepItem.add(const SizedBox(height: 4.0));
      stepItem.add(TextFormField(
        initialValue: widget.subjectInfo.operateSteps != null &&
                index < widget.subjectInfo.operateSteps.length
            ? widget.subjectInfo.operateSteps[index].timeCosts
            : '',
        decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
            labelText: "Time cost",
            hintText: 'Time cost of current step.'),
        onSaved: (String operation) {
//            widget._steps.operation = operation;
        },
//          validator: _validateTitle
      ));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: stepItem);
  }
}
