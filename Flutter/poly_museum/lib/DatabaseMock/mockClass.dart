class Musee {
  List<GroupeVisite> groupesVisite;
  List<ObjectForGame> objects;
  List<Plugin> plugins;
  String name;

  Musee(String name) {
    this.name = name;
    this.groupesVisite = new List();
    this.objects = new List();
    this.plugins = new List();
  }
}

class ObjectForGame {
  String name;
  String description;
  List<int> foundByTeams;

  ObjectForGame(String name, String description) {
    this.name = name;
    this.description = description;
    this.foundByTeams = new List();
  }
}

class Plugin {
  //USEFUL ?
}

class GroupeVisite {
  Game game;
  List<Member> members;
  String groupeCode;
  bool isFinished;
  bool isStarted;

  GroupeVisite(String groupeCode) {
    this.groupeCode = groupeCode;
    this.members = new List();
    this.isFinished = false;
    this.isStarted = false;
  }
}

class Member {
  String prenom;
}

class Game {
  List<List<Member>> teams;

  Game(List<Member> visitors) {
    
  }
}
