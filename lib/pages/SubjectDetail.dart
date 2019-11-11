import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tricks4live/tools/RequestParser.dart';
import 'package:tricks4live/tools/UserUtils.dart';
import 'package:tricks4live/entries/Subject.dart';
import 'package:tricks4live/entries/Label.dart';
import 'package:tricks4live/entries/User.dart' show Permission;
import 'package:tricks4live/pages/AddOrEditSubject.dart';
import 'package:tricks4live/pages/LoginUser.dart';
import 'package:tricks4live/generated/i18n.dart';
import 'package:tricks4live/widgets/LabelButton.dart';
import 'package:tricks4live/widgets/DialogShower.dart';
import 'package:tricks4live/tools/CommonUtils.dart';

class SubjectDetailPage extends StatefulWidget {
  final int subjectId;

  SubjectDetailPage(this.subjectId);

  @override
  State<StatefulWidget> createState() {
    return _SubjectDetailPageState();
  }
}

class _SubjectDetailPageState extends State<SubjectDetailPage> {
  Subject _subject;

  List<Comment> _hotComments = [];

  @override
  void initState() {
    super.initState();
    _getSubjectDetail();
    _fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
          expandedHeight: 256.0,
          pinned: true,
          actions: <Widget>[
            IconButton(
                icon: SvgPicture.asset('assets/icons/ic_edit.svg',
                    width: 28.0, height: 28.0),
                onPressed: () {
                  _editSubject();
                  print('Edit preesed');
                },
                tooltip: 'Improve')
          ],
          flexibleSpace: FlexibleSpaceBar(
              title: Text(S.of(context).pageSubjectDetail),
              background: Stack(fit: StackFit.expand, children: <Widget>[
                FadeInImage(
                    placeholder: AssetImage('assets/subject_placeholder.png'),
                    image: _subject != null && _subject.coverPicture != null
                        ? NetworkImage(_subject.coverPicture)
                        : AssetImage('assets/subject_placeholder.png')),
                const DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, -0.4),
                            colors: <Color>[
                      Color(0x60000000),
                      Color(0x00000000)
                    ])))
              ]))),
      SliverList(
          delegate: SliverChildListDelegate(<Widget>[
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildContent()),
        ),
        const SizedBox(height: 32.0),
        _buildHotComments()
      ]))
    ]));
  }

  Widget _buildCommentItem(Comment comment) {
    print(comment.toString());
    return Container(
        padding: const EdgeInsets.all(2.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            FadeInImage(
                placeholder: AssetImage('assets/subject_placeholder.png'),
                image: NetworkImage('${comment.commenter.avatar}'),
                width: 36.0,
                height: 36.0),
            const SizedBox(width: 4.0),
            Expanded(
                flex: 1,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(comment.commenter.nickName,
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.blueGrey)),
                      const SizedBox(height: 2.0),
                      Text(
                          CommonUtils.getNewsTimeStr(
                              comment.createDate, context),
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.grey))
                    ])),
            LabelButton(
              labelTxt: '${comment.agreeCount}',
              svgIcon: 'assets/icons/ic_praise_empty.svg',
              direction: IconDirection.right,
              iconSize: 18.0,
              textStyle: const TextStyle(fontSize: 14.0, color: Colors.orange),
              onPressed: () {},
            )
          ]),
          const SizedBox(height: 2.0),
          Text('${comment.content}',
              style: const TextStyle(fontSize: 14.0, color: Colors.black87)),
          const SizedBox(height: 2.0)
        ]));
  }

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  Widget _buildLabels() {
    if (_subject == null) {
      return null;
    }
    return Wrap(
      children: _subject.labels.map<Widget>((Label labe) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Chip(
              key: ValueKey<String>(labe.nameEN),
              backgroundColor: _nameToColor(labe.nameCN),
              label: Text(Localizations.localeOf(context).languageCode == 'en'
                  ? labe.nameEN
                  : labe.nameCN)),
        );
      }).toList(),
    );
  }

  List<Widget> _buildContent() {
    if (_subject == null) {
      return <Widget>[
        Center(child: Text(S.of(context).waitingForLoad))
      ];
    } else {
      List<Widget> content = <Widget>[
        Text(_subject.title,
            style: TextStyle(
                color: const Color(0xff283593),
                fontSize: 24.0,
                fontStyle: FontStyle.italic)),
        const SizedBox(height: 8.0),
        Container(alignment: Alignment.centerLeft, child: _buildLabels()),
        Text(CommonUtils.getNewsTimeStr(_subject.updateDate, context),
            textAlign: TextAlign.right,
            style: TextStyle(color: const Color(0xff9fa8da))),
        const SizedBox(height: 8.0),
        Text('    ${_subject.content}',
            style: TextStyle(fontSize: 16.0, color: const Color(0xff1a237e)))
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
      Text(S.of(context).operateSteps,
          style: const TextStyle(
              color: const Color(0xff283593),
              fontSize: 18.0,
              fontStyle: FontStyle.italic)),
      const SizedBox(height: 4.0)
    ];
    _subject.operateSteps.forEach((Steps steps) {
      stepsOperates.add(Text('${steps.operation}'));
      stepsOperates.add(Text('${steps.timeCosts.toString()}'));
      stepsOperates.add(Text('${steps.picture}'));
      stepsOperates.add(const SizedBox(height: 2.0));
    });
    return stepsOperates;
  }

  List<Widget> _buildContentFooter() {
    return <Widget>[
      const SizedBox(height: 8.0),
      const Divider(height: 1.0, color: const Color(0xff9fa8da)),
      const SizedBox(height: 8.0),
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            LabelButton(
                labelTxt: S.of(context).btnCollect,
                svgIcon: _subject.isCollected
                    ? 'assets/icons/ic_favorite_full.svg'
                    : 'assets/icons/ic_favorite_empty.svg',
                onPressed: _collectSubject),
            LabelButton(
                labelTxt: S.of(context).btnFocus,
                svgIcon: _subject.isFocused
                    ? 'assets/icons/ic_focus_full.svg'
                    : 'assets/icons/ic_focus_empty.svg',
                onPressed: _focusPublisher),
            const SizedBox(width: 36.0, height: 48.0),
            LabelButton(
                labelTxt:
                    '${S.of(context).btnValidate}: ${_subject.validCount}',
                svgIcon: _subject.isValidated
                    ? 'assets/icons/ic_praise_full.svg'
                    : 'assets/icons/ic_praise_empty.svg',
                onPressed: _validateSubject),
            LabelButton(
                labelTxt:
                    '${S.of(context).btnInValidate}: ${_subject.invalidCount}',
                svgIcon: _subject.isInvalidated
                    ? 'assets/icons/ic_tread_full.svg'
                    : 'assets/icons/ic_tread_empty.svg',
                onPressed: _invalidateSubject),
          ],
        ),
      )
    ];
  }

  Widget _buildHotComments() {
    List<Widget> commentItems = <Widget>[
      Text(S.of(context).hotComments,
          style: TextStyle(
              color: const Color(0xff283593),
              fontSize: 18.0,
              fontStyle: FontStyle.italic)),
      const Divider(height: 3.0, color: const Color(0xff9fa8da)),
    ];
    if (_hotComments == null || _hotComments.isEmpty) {
      commentItems.add(SizedBox(
          height: 64.0,
          child:
              Center(child: Text(S.of(context).noComments))));
    } else {
      _hotComments.forEach((comment) {
        commentItems.add(_buildCommentItem(comment));
      });

      commentItems.add(SizedBox(
          height: 64.0,
          child: Center(
              child: FlatButton(
                  onPressed: () {},
                  child: Text(S.of(context).moreComments,
                      style: TextStyle(
                          fontSize: 14.0, color: Colors.blueAccent))))));
    }
    Container container = Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: commentItems));
    return container;
  }

  void _getSubjectDetail() {
    print(UserUtil.getInstance().loginUser.toString());
    RequestParser.getSubjectDetail(widget.subjectId,
            userId: UserUtil.getInstance().loginUser == null
                ? null
                : UserUtil.getInstance().loginUser.id)
        .then((result) {
      if (result is Subject) {
        print(result.toString());
        _subject = result;
        setState(() {});
      }
    });
  }

  void _collectSubject() {
    if (__verifyLoginAndPermission()) {
      RequestParser.collectSubject(!_subject.isCollected,
              subjectId: _subject.id,
              userId: UserUtil.getInstance().loginUser.id)
          .then((result) {
        if (result.code == 200) {
          _subject.isCollected = !_subject.isCollected;
          setState(() {});
        } else {
          print(result.toString());
          //todo
        }
      });
    }
  }

  void _focusPublisher() {
    if (__verifyLoginAndPermission()) {
      RequestParser.focusUser(!_subject.isFocused,
              whichUser: UserUtil.getInstance().loginUser.id,
              focusWho: _subject.user.id)
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

  void _validateSubject() {
    if (__verifyLoginAndPermission()) {
      RequestParser.validateSubject(!_subject.isValidated,
              subjectId: _subject.id,
              userId: UserUtil.getInstance().loginUser.id)
          .then((result) {
        if (result.code == 200) {
          _subject.isValidated = !_subject.isValidated;
          if (_subject.isValidated) {
            _subject.validCount++;
            if (_subject.isInvalidated) {
              _subject.isInvalidated = !_subject.isInvalidated;
              _subject.invalidCount--;
            }
          } else {
            _subject.validCount--;
          }
          setState(() {});
        } else {
          print(result.toString());
          //todo
        }
      });
    }
  }

  void _invalidateSubject() {
    if (__verifyLoginAndPermission()) {
      RequestParser.invalidateSubject(!_subject.isInvalidated,
              subjectId: _subject.id,
              userId: UserUtil.getInstance().loginUser.id)
          .then((result) {
        if (result.code == 200) {
          _subject.isInvalidated = !_subject.isInvalidated;
          if (_subject.isInvalidated) {
            _subject.invalidCount++;
            if (_subject.isValidated) {
              _subject.isValidated = !_subject.isValidated;
              _subject.validCount--;
            }
          } else {
            _subject.invalidCount--;
          }
          setState(() {});
        } else {
          print(result.toString());
          //todo
        }
      });
    }
  }

  bool __verifyLoginAndPermission() {
    if (!UserUtil.getInstance().userHasLogin()) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
      return false;
    } else {
      if (!UserUtil.getInstance().hasPermission(Permission.BASE)) {
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
        child: AlertDialog(
            contentPadding: EdgeInsets.all(16.0),
            content: Text(S.of(context).verifyEmailHint),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, DialogAction.cancel);
                  },
                  child: Text(S.of(context).btnCancel)),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, DialogAction.ok);
                  },
                  child: Text(S.of(context).btnSend))
            ]),
        action: (value) {
          if (value == DialogAction.ok) {
            //todo
          }
        });
  }

  void _fetchComments() {
    RequestParser.getHottestComments(subjectId: widget.subjectId)
        .then((listComments) {
      print(listComments.toString());
      if (listComments is List<Comment>) {
        _hotComments = listComments;
        setState(() {});
      }
    }).catchError(() {
      //todo
    });
  }

  void _editSubject() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SubjectEditPage(subjectInfo: _subject);
    })).then((subject) {
      _subject = subject;
      setState(() {});
    });
  }
}
