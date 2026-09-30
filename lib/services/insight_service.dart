class InsightService {

  static String getInsight(List<String> moods){

    if(moods.isEmpty){
      return "Start checking in daily to discover your emotional patterns.";
    }

    int happy = moods.where((m)=>m=="Happy").length;
    int calm = moods.where((m)=>m=="Calm").length;
    int anxious = moods.where((m)=>m=="Anxious").length;
    int sad = moods.where((m)=>m=="Sad").length;

    if(happy>=5){
      return "You've experienced lots of joyful moments recently. Celebrate them.";
    }

    if(calm>=5){
      return "You've maintained a calm rhythm lately. Keep protecting your peace.";
    }

    if(anxious>=4){
      return "You've been feeling anxious quite often. Remember to slow down and be gentle with yourself.";
    }

    if(sad>=4){
      return "This has been a difficult season. Remember that difficult seasons don't last forever.";
    }

    return "Every emotion tells a story. Keep checking in with yourself.";
  }

}