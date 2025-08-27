import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  // プレイヤーのステータス
  int playerHP = 100;
  int playerMaxHP = 100;
  int playerMP = 50;
  int playerMaxMP = 50;

  // 敵のステータス
  int enemyHP = 80;
  int enemyMaxHP = 80;
  
  // 選択されたコマンド
  BattleCommand? selectedCommand;
  
  // バトルメッセージ
  String battleMessage = 'バトル開始！';

  @override
  Widget build(BuildContext context) {
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
              // 上部：HP/MPステータス表示
              _buildStatusArea(),
              
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
  }

  Widget _buildStatusArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // プレイヤーステータス
          Expanded(
            child: _buildPlayerStatus(),
          ),
          const SizedBox(width: 20),
          // 敵ステータス
          Expanded(
            child: _buildEnemyStatus(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerStatus() {
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
          _buildHPBar('HP', playerHP, playerMaxHP, Colors.red),
          const SizedBox(height: 4),
          _buildHPBar('MP', playerMP, playerMaxMP, Colors.blue),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              battleMessage,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
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
    setState(() {
      int damage = 15 + (DateTime.now().millisecond % 10);
      enemyHP = (enemyHP - damage).clamp(0, enemyMaxHP);
      battleMessage = '攻撃！ $damage のダメージを与えた！';
      
      if (enemyHP <= 0) {
        battleMessage += '\n敵を倒した！バトルに勝利！';
        context.go('/stage');
      } else {
        // 敵の反撃
        Future.delayed(const Duration(seconds: 2), () {
          _enemyAttack();
        });
      }
    });
  }

  void _executeSkill() {
    setState(() {
      if (playerMP >= 10) {
        int damage = 25 + (DateTime.now().millisecond % 15);
        enemyHP = (enemyHP - damage).clamp(0, enemyMaxHP);
        playerMP = (playerMP - 10).clamp(0, playerMaxMP);
        battleMessage = 'スキル発動！ $damage のダメージを与えた！MP -10';
        
        if (enemyHP <= 0) {
          battleMessage += '\n敵を倒した！バトルに勝利！';
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
    setState(() {
      int heal = 20 + (DateTime.now().millisecond % 10);
      playerHP = (playerHP + heal).clamp(0, playerMaxHP);
      battleMessage = 'ポーション使用！HPが $heal 回復した！';
      
      Future.delayed(const Duration(seconds: 2), () {
        _enemyAttack();
      });
    });
  }

  void _showStatus() {
    setState(() {
      battleMessage = 'プレイヤー HP:$playerHP/$playerMaxHP MP:$playerMP/$playerMaxMP\n敵 HP:$enemyHP/$enemyMaxHP';
    });
  }

  void _enemyAttack() {
    if (enemyHP > 0) {
      setState(() {
        int damage = 8 + (DateTime.now().millisecond % 8);
        playerHP = (playerHP - damage).clamp(0, playerMaxHP);
        battleMessage = '敵の攻撃！ $damage のダメージを受けた！';
        
        if (playerHP <= 0) {
          battleMessage += '\nHPが0になった...敗北...';
        }
      });
    }
  }
}
