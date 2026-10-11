import { BaseClass } from "../common/BaseClass"
import { table } from "../common/table"
import { Message } from "../sysInfo/SysInfoController"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, SetAnchoredPosition } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { ElimBlockDisplay } from "./ElimBlockDisplay"
import { ElimDefine } from "./ElimDefine"
import { ElimGameMgr } from "./ElimGameMgr"
import { ElimUtil } from "./ElimUtil"


/**棋盘界面 */
export class ElimChessBoardDisplay extends BaseClass {
    begin_pos
    blocks
    con_parent
    context
    current_block
    detal_dir
    detal_x
    detal_y
    drag_limit_dis
    elim_time
    game_mgr
    is_hint
    is_input
    shake_blocks
    timer_id
    x_len
    y_len
    ChessBuffType = ElimDefine.ChessBuffType
    can_drag = false
    event1
    event2
    event3
    public constructor() {
        super()

        this.game_mgr = ElimGameMgr.GetInstance()
        this.detal_x = 0
        this.detal_y = 0
        this.elim_time = 0
        this.shake_blocks = []
        this.detal_dir = new Vector2(0, 0)
        this.current_block = null
    }

    /*
        初始化棋盘
    */
    public Init(context?) {

        if (!this.con_parent) {
            //error("缺少父节点")
        }
        this.InitEvent()

        //Message.show("//////////////////////////-> 初始化棋盘")
        this.context = context
        this.x_len = context.x_len
        this.y_len = context.y_len
        this.drag_limit_dis = context.drag_limit_dis
        let board_data = context.board_data
        let buff_data = context.buff_data
        let block: ElimBlockDisplay
        let blocks = []
        let load_cnt = 0
        let max_load_cnt = this.x_len * this.y_len
        let LoadCallback = () => {
            load_cnt = load_cnt + 1
            if (load_cnt >= max_load_cnt) {
                this.OnBoardLoaded()
            }
        }
        for (let x = 0; x < this.x_len; x++) {
            blocks[x] = []
            for (let y = 0; y < this.y_len; y++) {
                block = new ElimBlockDisplay(this.con_parent)
                block.LoadChess(board_data[x][y], x, y, null, null, LoadCallback)
                let [pos_x, pos_y] = ElimUtil.GetAnchoredPos(x, y)
                block.SetPosition(pos_x, pos_y)
                // block.ExcuteCallback(() => {
                //     GlobalTimerQuest.AddDelayQuest(() => {
                //         SetAnchoredPosition(block.display_obj, pos_x, pos_y)
                //     }, 0.1)

                // })
                blocks[x][y] = block
                block.Load()
            }
        }
        this.blocks = blocks

        if (buff_data) {
            this.InitBuff(buff_data)
        }
        this.elim_time = TimeUtil.getServerTime()
        this.StartCountdown()

        if (context.score) {
            this.game_mgr.Fire(ElimDefine.ElimEvent.UPDATE_SCORE, context.score)
        }
    }

    public ResetChessBoard(board_data?, buff_data?) {

        for (let x = 0; x < this.x_len; x++) {
            for (let y = 0; y < this.y_len; y++) {
                let block = this.blocks[x][y]
                let chess = block.GetChess()
                if (!chess) {
                    block.LoadChess(board_data[x][y], x, y)
                } else {
                    chess.SetChessData(board_data[x][y])
                }
            }
        }
        if (buff_data) {
            this.InitBuff(buff_data)
        }
    }

    public Shuffle(action_list?) {

        let new_blocks = []
        for (let x = 0; x < this.x_len; x++) {
            new_blocks[x] = []
            for (let y = 0; y < this.y_len; y++) {
                let new_data = action_list[x][y]
                let old_x = new_data[0], old_y = new_data[1], new_chess_type = new_data[2], buff_type = new_data[3], buff_value = new_data[4]

                let old_block = this.blocks[old_x][old_y]
                new_blocks[x][y] = old_block
                if (new_chess_type) {
                    let chess = old_block.GetChess()
                    chess.SetChessType(new_chess_type)
                }
                if (buff_type) {
                    if (buff_type == -1) {
                        let chess = old_block.GetChess()
                        chess.SetBuff(null, null)
                    } else {
                        let chess = old_block.GetChess()
                        chess.SetBuff(buff_type, buff_value)
                    }
                }
                old_block.SetNewPos(x, y, true)
            }
        }
        this.blocks = new_blocks
        this.StopAllShake()
    }

    public InitBuff(buff_data?) {

        for (let _ = 0; _ < buff_data.length; _++) {
            let value = buff_data[_]
            let block = this.blocks[value[0]][value[1]]
            GlobalTimerQuest.AddDelayQuest(() => {
                let chess = block.GetChess()
                if(chess)chess.SetBuff(value[2], value[3])
            }, 0.5)

        }
    }

    public OnBoardLoaded() {
        this.game_mgr.NextAction()
    }

    public GetBlock(pos?):ElimBlockDisplay {

        if (!this.blocks) {
            return null
        }
        return this.blocks[pos[0]][pos[1]]
    }

    time_id_
    /**消除并播放消除特效 */
    public Elimnate(block_list?, callback?) {
        if (!this.blocks || !block_list) {
            if (callback) {
                callback()
            }
            return
        }

        let cur_step_buff=[]
        for (let _ in block_list) {
            var pos = block_list[_]
            let block:ElimBlockDisplay= this.blocks[pos[0]][pos[1]]
            if (block) {
                let buff_type = block.chess_item && block.chess_item.buff_type
                let time_out= ElimGameMgr.GetInstance().GetEffPlayTime(buff_type)
                if (time_out>0){
                    cur_step_buff.push(buff_type)
                    break;
                }
            }
        }


        let func = ()=>{
            for (let _ in block_list) {
                var pos = block_list[_]
                let block:ElimBlockDisplay= this.blocks[pos[0]][pos[1]]
                if (block) { 
                    if(block.GetChess()&&block.GetChess().chess_type==6){

                    }
                    block.RemoveChess()
                }
            }
            if (callback) {
                callback()
            }
            this.elim_time = TimeUtil.getServerTime()
        }

        func()
        // if(this.time_id_){
        //     clearTimeout(this.time_id_)
        //     this.time_id_=null
        // }

        // if(cur_step_buff.length==0){
        //     //无特效直接消除
        //     func()
        // }else{
        //     //先播放消除特效 再进行下一步
        //     let time_out= ElimGameMgr.GetInstance().GetEffPlayTime(cur_step_buff[0],true)
        //     this.time_id_=setTimeout(() => {
        //         func()
        //     }, time_out);
        // }


    }

    public InitEvent() {

        this.event1 = this.game_mgr.Bind(ElimDefine.ElimEvent.DRAG_BEGIN, (pos?) => {
            this.OnDragBegin(pos)
        })
        this.event2 = this.game_mgr.Bind(ElimDefine.ElimEvent.DRAG, (pos?) => {
            this.OnDrag(pos)
        })
        this.event3 = this.game_mgr.Bind(ElimDefine.ElimEvent.DRAG_END, (pos?) => {
            this.OnDragEnd(pos)
        })
    }

    public OnDragBegin(pos?) {

        this.begin_pos = pos
        let x = Math.ceil(pos.y / this.context.block_height) - 1
        let y = Math.ceil(pos.x / this.context.block_width) - 1

        if (this.blocks && x >= 0 && x < 8 && y >= 0 && y < 8 && this.blocks[x][y]) {
            this.current_block = this.blocks[x][y]
            this.can_drag = true
            //Message.show(`Type      ${this.current_block.chess_data}`)
        }
    }

    public OnDrag(pos?) {
        if (!this.can_drag) return
        if (!this.current_block) {
            return
        }

        if (this.is_input) {
            return
        }

        this.detal_x = pos.x - this.begin_pos.x
        this.detal_y = pos.y - this.begin_pos.y

        if (Math.abs(this.detal_x) < this.drag_limit_dis && Math.abs(this.detal_y) < this.drag_limit_dis) {
            return
        }

        if (Math.abs(this.detal_x) > Math.abs(this.detal_y)) {
            // 列移
            if (this.detal_x > 0) {
                this.detal_dir.x = 0
                this.detal_dir.y = 1
            } else {
                this.detal_dir.x = 0
                this.detal_dir.y = -1
            }
        } else {
            // 行移
            if (this.detal_y > 0) {
                this.detal_dir.x = 1
                this.detal_dir.y = 0
            } else {
                this.detal_dir.x = -1
                this.detal_dir.y = 0
            }
        }
        this.InputAction(this.detal_dir)

        this.detal_dir.x = 0
        this.detal_dir.y = 0
        this.detal_x = 0
        this.detal_y = 0
    }

    public OnDragEnd(pos?) {
        if (!this.can_drag) return
        this.current_block = null
        this.is_input = false
        this.can_drag = false
    }

    public InputAction(detal_dir?) {

        if (!detal_dir) {
            return
        }
        if (detal_dir.x == 0 && detal_dir.y == 0) {
            return
        }
        if (!this.current_block) {
            return
        }

        let target_x = this.current_block.x + detal_dir.x
        let target_y = this.current_block.y + detal_dir.y
        if (target_x < 0 || target_x > (this.x_len - 1)) {
            return
        }
        if (target_y < 0 || target_y > (this.y_len - 1)) {
            return
        }

        this.is_input = true
        let input_cmd = {
            source_pos: [
                this.current_block.x,
                this.current_block.y,
            ],
            target_pos: [
                target_x,
                target_y,
            ],
            dir: [
                detal_dir.x,
                detal_dir.y,
            ],
        }
        this.game_mgr.InputAction(input_cmd)
        this.is_hint = false
        this.StopAllShake()
    }

    public SetParent(con_parent?) {

        this.con_parent = con_parent
    }

    public FallIn(fallin_data?, action_wave?) {
        for (let _ in fallin_data) {
            var data = fallin_data[_]
            let s_block = this.GetBlock(data.source)
            let t_block = this.GetBlock(data.target)
            if (!t_block) {
            }
            let t_chess_item = t_block.ReplaceChess(s_block.GetChess())
            s_block.SetChessItem(t_chess_item)
            t_block.SetAnchoredPosByLogicPos(data.source[0], data.source[1])
            t_block.Back(action_wave)
        }
    }

    public GenAndFallIn(gen_data?, action_wave?) {

        for (let _ = 0; _ < gen_data.length; _++) {
            var data = gen_data[_]
            let pos = data[0], fall_pos = data[1], chess_type = data[2], buff_type = data[3], buff_value = data[4]
            let block = this.GetBlock(pos)
            if (block) {
                //block:SetLoadCallback(callback)
                block.LoadChess(chess_type, null, null, buff_type, buff_value)
                block.SetAnchoredPosByLogicPos(fall_pos[0], fall_pos[1])
                block.Back(action_wave)
            }
        }
    }

    public SwapChess(source_pos?, target_pos?) {

        let s_block = this.GetBlock(source_pos)
        let t_block = this.GetBlock(target_pos)
        let s_chess_item = s_block.GetChess()
        let t_chess_item = t_block.GetChess()
        s_block.SetChessItem(t_chess_item)
        t_block.SetChessItem(s_chess_item)
        s_block.Back(null, null, true)
        t_block.Back(null, null, true)
    }

    public DeleteMe() {

        if(this.time_id_){
            clearTimeout(this.time_id_)
            this.time_id_=null
        }

        if(this.event1)
        {
            this.game_mgr.UnBind(this.event1)
            this.event1 = null
        }
        if(this.event2)
        {
            this.game_mgr.UnBind(this.event2)
            this.event2 = null
        }
        if(this.event3)
        {
            this.game_mgr.UnBind(this.event3)
            this.event3 = null
        }
        this.OnDestroy()
    }

    public StartCountdown() {

        this.CancelTimer()
        this.timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
            this.CheckHint()
        }, 1)
        this.CheckHint()
    }

    public CancelTimer() {

        if (this.timer_id) {
            GlobalTimerQuest.CancelQuest(this.timer_id)
            this.timer_id = null
        }
    }

    public CheckHint() {

        if (TimeUtil.getServerTime() - this.elim_time >= ElimDefine.HINT_COUNTDOWN &&
            !this.is_hint) {
            this.elim_time = TimeUtil.getServerTime()
            this.OnHint()
        }
    }

    public OnHint() {

        this.StopAllShake()
        this.shake_blocks = []
        let board_gen = this.game_mgr.GetBoardGen()
        if (!board_gen) {
            return
        }
        let num, group_list = board_gen.CheckNewElimGroup(1)
        if (!group_list) {
            return
        }
        let list = group_list[0]
        if (!list) {
            return
        }
        for (let _ in list) {
            var value = list[_]
            let block = this.GetBlock(value)
            if (block && block.is_move) {
                return
            }
        }
        for (let _ in list) {
            var value = list[_]
            let block = this.GetBlock(value)
            if (block) {
                block.PlayShake()
                table.insert(this.shake_blocks, block)
            }
        }
        this.is_hint = true
    }

    public StopAllShake() {

        this.elim_time = TimeUtil.getServerTime()
        if (this.shake_blocks) {
            for (let _ in this.shake_blocks) {
                var block = this.shake_blocks[_]
                block.Back(null, null, true)
            }
            this.shake_blocks = []
        }
    }

    public OnDestroy() {

        this.StopAllShake()
        this.CancelTimer()
        this.con_parent = null
        if (this.blocks) {
            for (let i = 0; i < this.blocks.length; i++) {
                for (let j = 0; j < this.blocks[i].length; j++) {
                    this.blocks[i][j].DeleteMe()
                }
            }
            this.blocks = null
        }
    }

}