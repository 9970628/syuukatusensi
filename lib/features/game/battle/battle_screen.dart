import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sennsi_app/shared/models/task.dart';

enum BattleCommand {
  attack('攻撃'),
  skill('スキル'),
  item('アイテム'),
  status('ステータス');

  const BattleCommand(this.displayName);
  final String displayName;
}

class BattleScreen extends StatefulWidget {
  const BattleScreen({Key? key}) : super(key: key);

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  // 敵のステータス
  int enemyHP = 80;
  int enemyMaxHP = 80;
  
  // 選択されたコマンド
  BattleCommand? selectedCommand;
  
  // バトルメッセージ
  String battleMessage = 'バトル開始！';

  @override
  void initState() {
    super.initState();
    // 階層に応じて敵の強さを調整
    final gameModel = Provider.of<GameModel>(context, listen: false);
    final floor = gameModel.currentFloor;
    enemyMaxHP = 80 + (floor - 1) * 20;  // フロアが上がるごとに敵HPが20増加
    enemyHP = enemyMaxHP;
  }

  // タスク完了数に基づく攻撃力・スキル力を計算
  int _calculateAttackPower(GoalModel goalModel) {
    final completedSmallGoals = goalModel.mediumGoals
        .expand((goal) => goal.smallGoals)
        .where((small) => small.isCompleted)
        .length;
    final completedMediumGoals = goalModel.mediumGoals
        .where((goal) => goal.smallGoals.isNotEmpty && 
                       goal.smallGoals.every((small) => small.isCompleted))
        .length;
    
    // 基本攻撃力15 + 小タスク完了数×2 + 中間タスク完了数×5
    return 15 + (completedSmallGoals * 2) + (completedMediumGoals * 5);
  }

  int _calculateSkillPower(GoalModel goalModel) {
    final completedSmallGoals = goalModel.mediumGoals
        .expand((goal) => goal.smallGoals)
        .where((small) => small.isCompleted)
        .length;
    final completedMediumGoals = goalModel.mediumGoals
        .where((goal) => goal.smallGoals.isNotEmpty && 
                       goal.smallGoals.every((small) => small.isCompleted))
        .length;
    
    // 基本スキル攻撃力25 + 小タスク完了数×3 + 中間タスク完了数×8
    return 25 + (completedSmallGoals * 3) + (completedMediumGoals * 8);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GameModel, GoalModel>(
      builder: (context, gameModel, goalModel, child) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dungeon_corridor01.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // 上部：階層表示 + HP/MPステータス表示
                  _buildStatusArea(gameModel, goalModel),
                  
                  // 中央：バトル情報とメッセージ
                  Expanded(
                    flex: 2,
                    child: _buildBattleArea(),
                  ),
                  
                  // 下部：コマンド選択エリア
                  _buildCommandArea(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusArea(GameModel gameModel, GoalModel goalModel) {
    return Column(
      children: [
        // 階層表示
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Text(
            '${gameModel.currentFloor}階層',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // HP/MPステータス
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // プレイヤーステータス
              Expanded(
                child: _buildPlayerStatus(gameModel),
              ),
              const SizedBox(width: 20),
              // 敵ステータス
              Expanded(
                child: _buildEnemyStatus(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerStatus(GameModel gameModel) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'プレイヤー',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildHPBar('HP', gameModel.playerHP, gameModel.playerMaxHP, Colors.red),
          const SizedBox(height: 4),
          _buildHPBar('MP', gameModel.playerMP, gameModel.playerMaxMP, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildEnemyStatus() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '敵',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildHPBar('HP', enemyHP, enemyMaxHP, Colors.red),
        ],
      ),
    );
  }

  Widget _buildHPBar(String label, int current, int max, Color color) {
    double percentage = current / max;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $current/$max',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            widthFactor: percentage,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBattleArea() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '⚔️ バトル中 ⚔️',
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(
                  battleMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'コマンドを選択してください',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 2,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: BattleCommand.values.map((command) {
              return _buildCommandButton(command);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandButton(BattleCommand command) {
    bool isSelected = selectedCommand == command;
    
    return ElevatedButton(
      onPressed: () => _onCommandSelected(command),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.yellow : Colors.white,
        foregroundColor: isSelected ? Colors.black : Colors.blue[800],
        elevation: isSelected ? 8 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? Colors.orange : Colors.blue[300]!,
            width: 2,
          ),
        ),
      ),
      child: Text(
        command.displayName,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _onCommandSelected(BattleCommand command) {
    setState(() {
      selectedCommand = command;
      _executeCommand(command);
    });
  }

  void _executeCommand(BattleCommand command) {
    switch (command) {
      case BattleCommand.attack:
        _executeAttack();
        break;
      case BattleCommand.skill:
        _executeSkill();
        break;
      case BattleCommand.item:
        _executeItem();
        break;
      case BattleCommand.status:
        _showStatus();
        break;
    }
  }

  void _executeAttack() {
    final goalModel = Provider.of<GoalModel>(context, listen: false);
    final gameModel = Provider.of<GameModel>(context, listen: false);
    
    setState(() {
      int baseDamage = _calculateAttackPower(goalModel);
      int damage = baseDamage + (DateTime.now().millisecond % 10);
      enemyHP = (enemyHP - damage).clamp(0, enemyMaxHP);
      battleMessage = '攻撃！ $damage のダメージを与えた！';
      
      if (enemyHP <= 0) {
        battleMessage += '\n敵を倒した！バトルに勝利！';
        gameModel.nextFloor(); // 次の階層へ
        // 少し遅延してからstage画面に遷移
        Future.delayed(const Duration(seconds: 2), () {
          context.go('/stage');
        });
      } else {
        // 敵の反撃
        Future.delayed(const Duration(seconds: 2), () {
          _enemyAttack();
        });
      }
    });
  }

  void _executeSkill() {
    final goalModel = Provider.of<GoalModel>(context, listen: false);
    final gameModel = Provider.of<GameModel>(context, listen: false);
    
    setState(() {
      if (gameModel.playerMP >= 10) {
        int baseSkillDamage = _calculateSkillPower(goalModel);
        int damage = baseSkillDamage + (DateTime.now().millisecond % 15);
        enemyHP = (enemyHP - damage).clamp(0, enemyMaxHP);
        gameModel.useMp(10);
        battleMessage = 'スキル発動！ $damage のダメージを与えた！MP -10';
        
        if (enemyHP <= 0) {
          battleMessage += '\n敵を倒した！バトルに勝利！';
          gameModel.nextFloor(); // 次の階層へ
          // 少し遅延してからstage画面に遷移
          Future.delayed(const Duration(seconds: 2), () {
            context.go('/stage');
          });
        } else {
          Future.delayed(const Duration(seconds: 2), () {
            _enemyAttack();
          });
        }
      } else {
        battleMessage = 'MPが足りません！';
      }
    });
  }

  void _executeItem() {
    final gameModel = Provider.of<GameModel>(context, listen: false);
    
    setState(() {
      int heal = 20 + (DateTime.now().millisecond % 10);
      gameModel.heal(heal);
      battleMessage = 'ポーション使用！HPが $heal 回復した！';
      
      Future.delayed(const Duration(seconds: 2), () {
        _enemyAttack();
      });
    });
  }

  void _showStatus() {
    final goalModel = Provider.of<GoalModel>(context, listen: false);
    final gameModel = Provider.of<GameModel>(context, listen: false);
    final completedSmallGoals = goalModel.mediumGoals
        .expand((goal) => goal.smallGoals)
        .where((small) => small.isCompleted)
        .length;
    final completedMediumGoals = goalModel.mediumGoals
        .where((goal) => goal.smallGoals.isNotEmpty && 
                       goal.smallGoals.every((small) => small.isCompleted))
        .length;
    final attackPower = _calculateAttackPower(goalModel);
    final skillPower = _calculateSkillPower(goalModel);
    
    setState(() {
      battleMessage = '''階層: ${gameModel.currentFloor}
プレイヤー HP:${gameModel.playerHP}/${gameModel.playerMaxHP} MP:${gameModel.playerMP}/${gameModel.playerMaxMP}
敵 HP:$enemyHP/$enemyMaxHP

タスク完了状況:
小タスク完了: $completedSmallGoals個
中間タスク完了: $completedMediumGoals個
攻撃力: $attackPower
スキル攻撃力: $skillPower''';
    });
  }

  void _enemyAttack() {
    final gameModel = Provider.of<GameModel>(context, listen: false);
    
    if (enemyHP > 0) {
      setState(() {
        int damage = 8 + (DateTime.now().millisecond % 8);
        gameModel.takeDamage(damage);
        battleMessage = '敵の攻撃！ $damage のダメージを受けた！';
        
        if (gameModel.playerHP <= 0) {
          battleMessage += '\nHPが0になった...敗北...';
          context.go('/home');
        }
      });
    }
  }
}
