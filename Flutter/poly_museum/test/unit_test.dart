import 'package:flutter_test/flutter_test.dart';
import 'package:poly_museum/global.dart';
import 'package:poly_museum/services/service_provider.dart';

void main() {
  test('my first unit test', () {
    var answer = 42;
    expect(answer, 42);
  });

  test('startGame', () async {
    changeMuseumTarget("NiceTest");
    var gameService = ServiceProvider.gameService;
    gameService.startGame(null, 1);
    gameService.updateGameStatus(null, 1);
    expect(true, gameService.gameStatusBegin);
  });

  ServiceProvider.groupService.streamGroups();
  test('Check if user is added to group', () async {
    changeMuseumTarget("NiceTest");
    var length = ServiceProvider.groupService.groups.length;
    print('la');
    print(length);
    ServiceProvider.groupService
        .addMemberToGroup("Gilles", "1234")
        .then((result) {
      print(result);
      expect(ServiceProvider.groupService.groups.length, length + 1);
    });
  });
}
