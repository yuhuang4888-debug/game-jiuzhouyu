import { BaseClass } from "../common/BaseClass"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalTimerQuest, Util } from "../util/Util"
import { ElimChessBoardDisplay } from "./ElimChessBoardDisplay"
import { ElimDefine } from "./ElimDefine"
import { ElimGameMgr } from "./ElimGameMgr"

/***注册旗子动作 */
export class ElimActionDisplay extends BaseClass {
    board_display: ElimChessBoardDisplay
    game_mgr: ElimGameMgr
    private ActionCMD = ElimDefine.ActionCMD

    public constructor() {
        super()

        this.game_mgr = ElimGameMgr.GetInstance()
        this.board_display = this.game_mgr.GetBoardDisplay()

        this.InitEvent()
    }

    public InitEvent() {

        this.game_mgr.Bind(ElimDefine.ElimEvent.ACTION_EXCUTE, (action_id?, action?) => {
            this.RealExcuteAction(action_id, action)
        })
    }

    public DeleteMe() {


    }

    public InitBoardFunc = (action) => {
        let context = action[1]
        this.board_display.Init(context)
    }

    public SwapFunc = (action) => {
        let ret = action[1]
        let source_pos = action[2]
        let target_pos = action[3]
        let s_block = this.board_display.GetBlock(source_pos)
        let t_block = this.board_display.GetBlock(target_pos)
        let back_num = 0
        let callback = () => {
            back_num = back_num + 1
            if (back_num == 2) {
                if (ret) {
                    //let t_chess_item = t_block.ReplaceChess(s_block.GetChess())
                    //s_block:SetChessItem(t_chess_item)
                    this.board_display.SwapChess(source_pos, target_pos)
                    //s_block:Back(null, true)
                    //t_block:Back(null, true)
                }
                this.Next()
            }
        }
        s_block.PlayMoveAnim(target_pos, !ret, callback)
        t_block.PlayMoveAnim(source_pos, !ret, callback)
    }

    public ElimFunc = (action) => {
        let block_list = action[1]
        this.board_display.Elimnate(block_list, () => {
            this.Next()
        })
    }

    /**旗子出生时掉落动画 */
    public FallInFunc = (action) => {
        let fallin_data = action[1]
        let gen_data = action[2]
        let action_wave = action[3]

        ElimGameMgr.GetInstance().current_move_num = fallin_data.length + gen_data.length

        //把棋盘上已经存在的旗子 掉落填补到空缺位置
        if (fallin_data && Util.TableSize(fallin_data) > 0) {
            this.board_display.FallIn(fallin_data, action_wave)
        }

        //生成一些新的旗子，并填补到空缺
        if (gen_data) {
            this.board_display.GenAndFallIn(gen_data, action_wave)
        }
        GlobalTimerQuest.AddDelayQuest(() => {
            this.Next()
        }, 0.4)

    }

    public GenSpecialFunc = (action) => {
        let chess_type = action[1]
        let new_pos = action[2]
        let buff_type = action[3]
        let block = this.board_display.GetBlock(new_pos)
        if (block) {
            block.LoadChess(chess_type, null, null, buff_type)
        }
        this.Next()
    }

    public ResetBoardFunc = (action) => {
        Message.show("当前无可碰撞的达摩，已为您重置")
        let board_data = action[1]
        let buff_data = action[2]
        this.board_display.ResetChessBoard(board_data, buff_data)
        this.Next()
    }

    public ShuffleFunc = (action) => {
        Message.show("当前无可碰撞的达摩，已为您重置")
        let action_list = action[1]
        this.board_display.Shuffle(action_list)
        this.Next()
    }

    public BonusTimeBeginFunc = (action) => {
        this.Next()
    }

    public BonusTimeEndFunc = (action) => {
        this.game_mgr.Fire(ElimDefine.ElimEvent.BONUS_TIME_END)
        this.Next()
    }

    /**触发棋子特效效果 */
    public TriggerBuff = (action) => {
        this.Next()
    }

    public ActionCMD2Func = {
        [this.ActionCMD.INIT_BOARD]: this.InitBoardFunc,
        [this.ActionCMD.SWAP]: this.SwapFunc,
        [this.ActionCMD.ELIM]: this.ElimFunc,
        [this.ActionCMD.FALL_IN]: this.FallInFunc,
        [this.ActionCMD.GEN_SPECIAL]: this.GenSpecialFunc,
        [this.ActionCMD.RESET]: this.ResetBoardFunc,
        [this.ActionCMD.SHUFFLE]: this.ShuffleFunc,
        [this.ActionCMD.BONUS_TIME_BEGIN]: this.BonusTimeBeginFunc,
        [this.ActionCMD.BONUS_TIME_END]: this.BonusTimeEndFunc,
        [this.ActionCMD.TRIGGER_BUFF]: this.TriggerBuff
    }

    public RealExcuteAction(action_id?, action?) {

        if (!this.board_display) {
            return
        }
        if (this.ActionCMD2Func[action_id]) {
            this.ActionCMD2Func[action_id](action)
        }
    }

    public Next() {
        this.game_mgr.NextAction()
    }
}