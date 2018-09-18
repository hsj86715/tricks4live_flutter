import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../tools/request_parser.dart';
import '../tools/user_tool.dart';
import '../entries/subject.dart';
import '../entries/label.dart';
import '../entries/user.dart' show Permission;
import '../entries/results.dart';
import 'add_edit_subject.dart';
import 'login_user.dart';
import '../widgets/label_button.dart';
import '../widgets/dialog_shower.dart';

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
                icon: new SvgPicture.asset('assets/icons/ic_edit.svg',
                    width: 28.0, height: 28.0),
                onPressed: () {
                  _editSubject();
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
      content.addAll(_buildContentFooter());
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

  List<Widget> _buildContentFooter() {
    final GlobalKey _collectTextKey = new GlobalKey();

    return <Widget>[
      const SizedBox(height: 8.0),
      const Divider(height: 1.0, color: const Color(0xff9fa8da)),
      const SizedBox(height: 8.0),
      new Container(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new LabelButton(
              labelTxt: 'Collect',
              svgIcon: _subject.isCollected
                  ? 'assets/icons/ic_favorite_full.svg'
                  : 'assets/icons/ic_favorite_empty.svg',
              onPressed: _collectSubject,
            ),
            new LabelButton(
                labelTxt: 'Focus',
                svgIcon: _subject.isFocused
                    ? 'assets/icons/ic_focus_full.svg'
                    : 'assets/icons/ic_focus_empty.svg',
                onPressed: _focusPublisher),
            const SizedBox(width: 48.0, height: 48.0),
            new LabelButton(
                labelTxt: 'Valid: ${_subject.validCount}',
                svgIcon: _subject.isValidated
                    ? 'assets/icons/ic_praise_full.svg'
                    : 'assets/icons/ic_praise_empty.svg',
                onPressed: () {}),
            new LabelButton(
                labelTxt: 'Invalid: ${_subject.invalidCount}',
                svgIcon: _subject.isInvalidated
                    ? 'assets/icons/ic_tread_full.svg'
                    : 'assets/icons/ic_tread_empty.svg',
                onPressed: () {}),
          ],
        ),
      )
    ];
  }

  void _getSubjectDetail() {
    RequestParser.getSubjectDetail(widget.subjectId,
            userId: UserUtil.loginUser == null ? null : UserUtil.loginUser.id)
        .then((result) {
      if (result is Subject) {
        print(result.toString());
        _subject = result;
        setState(() {});
      }
    });
  }

  void _collectSubject() {
    if (!UserUtil.userHasLogin()) {
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
        return new LoginPage();
      }));
    } else {
      if (UserUtil.hasPermission(Permission.BASE)) {
        RequestParser.collectSubject(!_subject.isCollected,
                subjectId: _subject.id, userId: UserUtil.loginUser.id)
            .then((result) {
          if (result.code == 200) {
            _subject.isCollected = !_subject.isCollected;
            setState(() {});
          } else {
            print(result.toString());
            //todo
          }
        });
      } else {
        _showEmailVerifyDialog();
      }
    }
  }

  void _focusPublisher() {
    if (__verifyLoginAndPermission()) {
      RequestParser.focusUser(!_subject.isFocused,
              whichUser: UserUtil.loginUser.id, focusWho: _subject.user.id)
          .then((result) {
        if (result.code == 200) {
          _subject.isFocused = !_subject.isFocused;
          setState(() {});
        } else {
          print(result.toString());
          //todo
        }
      });
    }
  }

  bool __verifyLoginAndPermission() {
    if (!UserUtil.userHasLogin()) {
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
        return new LoginPage();
      }));
      return false;
    } else {
      if (!UserUtil.hasPermission(Permission.BASE)) {
        _showEmailVerifyDialog();
        return false;
      } else {
        return true;
      }
    }
  }

  void _showEmailVerifyDialog() {
    showCustomDialog(
        context: context,
        child: new AlertDialog(
          contentPadding: EdgeInsets.all(16.0),
          content: new Text(
              'Your Email has not been verified. Send verify email now?'),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.pop(context, DialogAction.cancel);
                },
                child: const Text('CANCEL')),
            new FlatButton(
                onPressed: () {
                  Navigator.pop(context, DialogAction.ok);
                },
                child: new Text('SEND'))
          ],
        ),
        action: (value) {
          if (value == DialogAction.ok) {
            //todo
          }
        });
  }

  void _editSubject() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new SubjectEditPage(subjectInfo: _subject);
    })).then((subject) {
      _subject = subject;
      setState(() {});
    });
  }
}
