import 'package:election_exit_poll_620710313/models/candidate_info.dart';
import 'package:election_exit_poll_620710313/pages/candidate_poll.dart';
import 'package:election_exit_poll_620710313/services/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CandidatePage extends StatefulWidget {
  static const routeName = '/candidate_page';

  const CandidatePage({Key? key}) : super(key: key);

  @override
  _CandidatePageState createState() => _CandidatePageState();
}

class _CandidatePageState extends State<CandidatePage> {
  Future<List<CandidateInfo>>? _futureCandidatePage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<CandidateInfo>>(
        // รอข้อมูลให้เราแทนจะไป then ใน init
        future: _futureCandidatePage,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // ถ้า future ยังไม่สมบูรณ์จะแสดงหมุนๆ
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('ERROR! : ${snapshot.error}'),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _futureCandidatePage =
                              _loadCandidate(); // กดเพื่อลองใหม่
                        });
                      },
                      child: Text('Retry'))
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            return SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  image: const DecorationImage(
                    image: const AssetImage("assets/images/bg.png"),
                    fit: BoxFit
                        .fill, // ยืดเต็มพื้นที่โดยไม่สนใจสัดส่วนของภาพ หรือใช้ BoxFit.cover เพื่อยืดให้เต็มและคงสัดส่วนของภาพไว้ แต่บางส่วนของภาพอาจถูก crop
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 10.0,),
                    Image(
                      image: AssetImage('assets/images/vote_hand.png'),
                      width: 80,
                    ),
                    SizedBox(height: 8.0,),
                    Text('EXIT POLL', style: TextStyle(fontSize: 20.0,color: Colors.grey)),
                    SizedBox(height: 10.0,),
                    Text('เลือกตั้งอบต.', style: GoogleFonts.prompt(fontSize: 25.0,color: Colors.white)),
                    SizedBox(height: 10.0,),
                    Text('รายชื่อผู้สมัครรับเลือกตั้ง',
                        style: GoogleFonts.prompt(fontSize: 15.0,color: Colors.white)),
                    Text('นายกองค์การบริหารส่วนตำบลเขาพระ',
                        style: GoogleFonts.prompt(fontSize: 15.0,color: Colors.white)),
                    Text('อำเภอเมืองนครนายก จังหวัดนครนายก',
                        style: GoogleFonts.prompt(fontSize: 15.0,color: Colors.white)),
                    SizedBox(height: 20.0,),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        itemCount: snapshot.data!.length, //ใช้ snap มาแทน list
                        // list ของ fooditem คือ รายการที่ออกเป็น list ของ dart แล้ว
                        itemBuilder: (BuildContext context, int index) {
                          var candidateInfo = snapshot.data![index];
                          return Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            margin: EdgeInsets.all(8.0),
                            elevation: 5.0,
                            shadowColor: Colors.black.withOpacity(0.2),
                            child: InkWell(
                              onTap: () =>
                                  _handleClickVote(candidateInfo.candidateNumber),
                              //เข้าไปดู detail ผ่านการกดปุ่ม
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    color: Colors.green,
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        candidateInfo.candidateNumber.toString(),
                                        style: GoogleFonts.prompt(fontSize: 30.0,color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                candidateInfo.candidateTitle,
                                                style: GoogleFonts.prompt(
                                                    fontSize: 15.0),
                                              ),
                                              Text(
                                                candidateInfo.candidateName,
                                                style: GoogleFonts.prompt(
                                                    fontSize: 15.0),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          setState(() {
                            Navigator.pushReplacementNamed(
                                context, CandidatePoll.routeName);
                          });
                        },
                        child: Text('                ดูผล                 '),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return SizedBox.shrink(); //ถ้าไม่มี
        },
      ),
    );
  }

  Future<List<CandidateInfo>> _loadCandidate() async {
    List response = await Api().fetch(
        'exit_poll'); // ได้เป็น map ของ data มาจากการ get (fetch) // foods คือ endpoint
    var candidateList = response
        .map((item) => CandidateInfo.fromJson(item))
        .toList(); // แปลง map เป็น odj FoodItem แล้วอย่าลืม .toList()
    // เรียกดูชื่ออาหารใน map ได้โดย : foodList[0].name;
    return candidateList; // ข้างบนคือ return fooditem ออกไป
  }

  _handleClickVote(int candidateNumber) async {
    var isCallApi = await _callApi(candidateNumber);
    if (isCallApi == null) return;

    var text = isCallApi.toString();

    print(text);
    _showMaterialDialog('SUCCESS', 'บันทึกข้อมูลสำเร็จ $text');
  }

  Future<List<dynamic>?> _callApi(candidateNumber) async {
    try {
      var isCallApi = (await Api()
              .submit('exit_poll', {'candidateNumber': candidateNumber}))
          as List<dynamic>; // as คือการ cast data
      print('DATA: $isCallApi');
      return isCallApi;
    } catch (e) {
      print(e);
      _showMaterialDialog('ERROR', e.toString());
      return null;
    } finally {}
  }

  @override // run แค่ครั้งเดียว หลังจากนั้นจะ call ไปที่ bulid แล้วค่อยมาทำ state ข้างใน init ทีหลัง // เป็น method ใน class state
  void initState() {
    // จะไม่ใช้ await // list คือค่าของ foodlist ที่ส่งมา
    super.initState(); // ต้องเรียก super เวลา override method
    _futureCandidatePage = _loadCandidate();
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg, style: Theme.of(context).textTheme.bodyText2),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
