import { BaseVo } from "../common/BaseVo"
import { EventDispatcher } from "../util/EventDispatcher"

export class ElimDefine extends EventDispatcher {

    // 提示间隔时间
    public static HINT_COUNTDOWN = 3
    public static ELIM_LIMIT_NUM = 3
    public static ELIM_UNIT_SPD = 0.35
    public static ELIM_SWAP_SPD = 0.35  //两个旗子交换动画用时

    public static Env = {
        XLength: 9,
        YLength: 9,
    }

    // 块类型
    public static BlockType = {
        None: 0,
        Normal: 1,
    }

    /*
        类型数值涉及到优先级  加类型记得修改 AnalyzeAndWeedOutFunc
    */
    public static ChunkType = {
        None: 0,
        ElimThree: 1,
        ElimXFour: 2,
        ElimYFour: 3,
        ElimCircle: 4,
        ElimStar: 5,      //彩蛋被其他特效棋子消除
        ElimSwapStar: 6, //彩蛋和其他旗子互换 引起的消除
        ElimSwapBuff: 7  //横竖圆&横竖圆互消除
    }
    /**棋子类型 */
    public static ChessType = {
        Color1: 1,
        Color2: 2,
        Color3: 3,
        Color4: 4,
        Color5: 5,

        ColorStar: 6,

        Special1: 6,   // 横向
        Special2: 7,   // 纵向
        Special3: 8,   // 矩形
        Special4: 9,   // 星星
    }


    /**消除特效类型 */
    public static ChessBuffType = {
        Row: 1,        // 行
        Col: 2,        // 列
        Circle: 3,        // 圆
        Star: 4,        // 星
        Score: 5,        // 分数
    }

    /**动画效果 */
    public static ActionCMD = {
        /**初始化棋盘 */
        INIT_BOARD: 1,
        /**交换 */
        SWAP: 2,
        /**消除 */
        ELIM: 3,
        /**生成带buff的棋子 */
        GEN_SPECIAL: 4,
        GEN_CHUNK: 5,
        /**废弃*/
        TRIGGER_BUFF: 6,
        /**把已经存在的棋子往下挪，并生成一些新的填补位置，（这一步会包含一些消除动作） */
        FALL_IN: 7,
        /**重置 */
        RESET: 8,
        /**洗牌 */
        SHUFFLE: 9,
        /***奖励时间开始 */
        BONUS_TIME_BEGIN: 10,
        /**奖励时间结束 */
        BONUS_TIME_END: 11,
    }

    public static BlockDirection = {
        [0]: [-1, 0],      // 下移
        [1]: [1, 0],
        [2]: [0, 1],
        [3]: [0, -1],
    }

    public static AxisDirection = {
        X: 1,
        Y: 2,
    }

    public static ElimEvent = {
        ACTION_EXCUTE: "ACTION_EXCUTE",  // action
        START_SHOW: "START_SHOW",  // 开始
        DRAG_BEGIN: "DRAG_BEGIN",
        DRAG: "DRAG",
        DRAG_END: "DRAG_END",
        UPDATE_SCORE: "UPDATE_SCORE",
        BONUS_TIME_END: "BONUS_TIME_END",
        SET_BUFF_SHOW: "SET_BUFF_SHOW",
        FIRE_BLOCK_EFFECT: "FIRE_BLOCK_EFFECT",
        ALL_CHESS_FALL_IN_OVER: "ALL_CHESS_FALL_IN_OVER", //所有旗子生成掉落完成
        CHUNK_CHESS_WAIT_DEAL: "CHUNK_CHESS_DEAL", //异步处理
        CHUNK_CHESS_WAIT_DEAL_OVER: "CHUNK_CHESS_WAIT_DEAL_OVER", //异步处理完成
        CHANGE_CHESS_BUFF_TYPE: "CHANGE_CHESS_BUFF_TYPE", //秘籍用 修改旗子的类型
        ELIM_RESET_BOARD: "ELIM_RESET_BOARD" //重置棋盘
    }

    /*
        消除回合下落速度
    */
    public static ActionWave2Spd = {
        [0]: ElimDefine.ELIM_UNIT_SPD,
        [1]: ElimDefine.ELIM_UNIT_SPD / 1.2,
        [2]: ElimDefine.ELIM_UNIT_SPD / 1.4,
        [3]: ElimDefine.ELIM_UNIT_SPD / 1.6,
        [4]: ElimDefine.ELIM_UNIT_SPD / 1.8,
        [5]: ElimDefine.ELIM_UNIT_SPD / 2,
        [6]: ElimDefine.ELIM_UNIT_SPD / 2.2,
        [7]: ElimDefine.ELIM_UNIT_SPD / 2.4,
        [8]: ElimDefine.ELIM_UNIT_SPD / 2.6,
        [9]: ElimDefine.ELIM_UNIT_SPD / 2.8,
        [10]: ElimDefine.ELIM_UNIT_SPD / 3,
    }


    static UseTestMap = false
    static GMOpen = true
}