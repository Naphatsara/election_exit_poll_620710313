import 'package:election_exit_poll_620710313/models/candidate_info.dart';
import 'package:election_exit_poll_620710313/models/candidate_result.dart';
import 'package:election_exit_poll_620710313/services/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CandidatePoll extends StatefulWidget {

  static const routeName = '/candidate_poll';

  const CandidatePoll({Key? key}) : super(key: key);

  @override
  _CandidatePollState createState() => _CandidatePollState();
}

class _CandidatePollState extends State<CandidatePoll> {

  Future<List<CandidateResult>>? _futureCandidatePoll;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<CandidateResult>>(
        // รอข้อมูลให้เราแทนจะไป then ใน init
        future: _futureCandidatePoll,
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
                  ElevatedButton(onPressed: () {
                    setState(() {
                      _futureCandidatePoll = _loadCandidatePoll(); // กดเพื่อลองใหม่
                    });
                  }, child: Text('Retry'))
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            // check ว่าข้อมูลมาหรือยัง ถ้ามี
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
                    Text('EXIT POLL', style: GoogleFonts.prompt(fontSize: 20.0,color: Colors.grey)),
                    SizedBox(height: 10.0,),
                    Text('RESULT', style: GoogleFonts.prompt(fontSize: 25.0,color: Colors.white)),
                    SizedBox(height: 15.0,),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        itemCount: snapshot.data!.length, //ใช้ snap มาแทน list
                        // list ของ fooditem คือ รายการที่ออกเป็น list ของ dart แล้ว
                        itemBuilder: (BuildContext context, int index) {
                          var candidateResult = snapshot.data![index];
                          return Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            margin: EdgeInsets.all(8.0),
                            elevation: 5.0,
                            shadowColor: Colors.black.withOpacity(0.2),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  color: Colors.green,
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      candidateResult.candidateNumber.toString(),
                                      style: GoogleFonts.prompt(fontSize: 30.0,color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              candidateResult.candidateTitle,
                                              style: GoogleFonts.prompt(fontSize: 15.0),
                                            ),
                                            Text(
                                              candidateResult.candidateName,
                                              style: GoogleFonts.prompt(fontSize: 15.0),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  candidateResult.score.toString(),
                                  style: GoogleFonts.prompt(fontSize: 15.0),
                                )
                              ],
                            ),
                          );
                        },
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
  Future<List<CandidateResult>> _loadCandidatePoll() async {
    List response = await Api().fetch('exit_poll/result'); // ได้เป็น map ของ data มาจากการ get (fetch) // foods คือ endpoint
    var candidateList = response.map((item) => CandidateResult.fromJson(item)).toList(); // แปลง map เป็น odj FoodItem แล้วอย่าลืม .toList()
    // เรียกดูชื่ออาหารใน map ได้โดย : foodList[0].name;
    return candidateList; // ข้างบนคือ return fooditem ออกไป
  }
  @override // run แค่ครั้งเดียว หลังจากนั้นจะ call ไปที่ bulid แล้วค่อยมาทำ state ข้างใน init ทีหลัง // เป็น method ใน class state
  void initState() {
    // จะไม่ใช้ await // list คือค่าของ foodlist ที่ส่งมา
    super.initState(); // ต้องเรียก super เวลา override method
    _futureCandidatePoll = _loadCandidatePoll();
  }

}

