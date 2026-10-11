import { MiniGameModel } from "../commonModel/MiniGameModel"
import { EventDispatcher } from "../util/EventDispatcher"
import { Runner } from "../util/Runner"
import { ElimActionDisplay } from "./ElimActionDisplay"
import { ElimActionQueue } from "./ElimActionQueue"
import { ElimBoardGen } from "./ElimBoardGen"
import { ElimChessBoard } from "./ElimChessBoard"
import { ElimChessBoardDisplay } from "./ElimChessBoardDisplay"
import { ElimDefine } from "./ElimDefine"
/***消消乐游戏管理器 */
export class ElimGameMgr extends EventDispatcher {
    action_display: ElimActionDisplay
    action_queue: ElimActionQueue
    board_gen: ElimBoardGen
    chess_board: ElimChessBoard
    chess_board_display: ElimChessBoardDisplay
    context

    /***当前在移动的旗子数量 */
    current_move_num = 0
    /***当前在处理的棋子数量*/
    need_deal_num = 0
    /***当前特效播放次数 */
    cur_play_eff_num = 0
    /**当前是否在消除中 */
    is_eliming=false

    static Instance: ElimGameMgr
    public constructor() {
        super()

        if (ElimGameMgr.Instance) {
            return
        }
        ElimGameMgr.Instance = this
        this.InitEvent()
    }

    public Init() {

        Runner.GetInstance().RemoveRunObj(this.hashCode)
        Runner.GetInstance().AddRunObj(this.hashCode)

        this.board_gen = new ElimBoardGen()
        this.context = this.GenContext()
        let context = this.context

        // 读配置
        let x, y = MiniGameModel.GetInstance().GetChessBoardLength()
        if (x && y) {
            context.x_len = x
            context.y_len = y
        }

        let [board_data, buff_data, score] = this.board_gen.GenChessBorad(context.x_len, context.y_len, context.limit_num)
        context.board_data = board_data
        context.buff_data = buff_data
        context.score = score

        this.chess_board_display = new ElimChessBoardDisplay()
        this.action_queue = new ElimActionQueue()
        this.action_display = new ElimActionDisplay()

        this.chess_board = new ElimChessBoard(context)
        this.chess_board.SetBoardDisplay(this.chess_board_display)
        this.chess_board.Init()

        //MiniGameModel:GetInstance():Fire(MiniGameModel.START_MINI_GAME, MiniGameModel.MiniGameType.Elim)
    }

    public GenContext() {

        return {
            x_len: 8,        // 棋盘行
            y_len: 8,        // 列
            limit_num: 3,        // 生成至少多少个可消除
            block_width: 73,     // 棋子宽
            block_height: 73,     // 棋子高
            drag_limit_dis: 40,        // 拖动最小距离
        }
    }

    public GetBoardGen(): ElimBoardGen {

        return this.board_gen
    }

    public GetBoardDisplay(): ElimChessBoardDisplay {

        return this.chess_board_display
    }

    public GetBlock(pos?) {

        return this.chess_board_display.GetBlock(pos)
    }

    public AddAction(action?) {

        if (this.action_queue) {
            this.action_queue.AddAction(action)
        }
    }

    public ClearAction(action?) {

        if (this.action_queue) {
            this.action_queue.ClearAction()
        }
    }

    public StartGame(game_obj?) {

        this.chess_board_display.SetParent(game_obj)
        this.NextAction()
    }

    public StopGame() {

        this.DeleteMe()
    }

    public InitEvent() {

        this.Bind(ElimDefine.ElimEvent.START_SHOW, (game_obj?) => {
            this.StartGame(game_obj)
        })
    }

    public InputAction(input_cmd?) {

        if (this.chess_board) {
            this.chess_board.InputAction(input_cmd)
        }
    }

    public StartBonusTime() {

        if (this.chess_board) {
            this.chess_board.StartBonusTime()
        }
    }

    public DeleteMe() {

        Runner.GetInstance().RemoveRunObj(this.hashCode)
        if (this.chess_board_display) {
            this.chess_board_display.DeleteMe()
            this.chess_board_display = null
        }

        if (this.chess_board) {
            this.chess_board.DeleteMe()
            this.chess_board = null
        }
        if (this.action_queue) {
            this.action_queue.DeleteMe()
            this.action_queue = null
        }

        ElimGameMgr.Instance = null
    }

    public NextAction() {
        if (this.action_queue) {
            this.action_queue.NextAction()
        }
    }

    public Update() {

        // TODO 调试
        if (this.action_queue) {
            this.action_queue.Update()
        }
    }

    /**
     * 
     * @param buff_type 
     * @param is_trans  是否转成倍率关系  用于调节特效和旗子消失的时机
     * @returns 
     */
    public GetEffPlayTime(buff_type,is_trans?) {
        let time_out = 0
        switch (buff_type) {
            case ElimDefine.ChessBuffType.Circle:
                time_out = 0.6
                break;
            case ElimDefine.ChessBuffType.Row:
                time_out = 1.1
                break;
            case ElimDefine.ChessBuffType.Col:
                time_out = 1.1
                break;
        }

        if(is_trans){
            time_out=buff_type==ElimDefine.ChessBuffType.Circle ? time_out * 1000 / 4 : time_out * 1000 / 4.5
        }

        return time_out
    }



    public static GetInstance() {
        if (!ElimGameMgr.Instance) {
            ElimGameMgr.Instance = new ElimGameMgr()
        }
        return ElimGameMgr.Instance
    }
}