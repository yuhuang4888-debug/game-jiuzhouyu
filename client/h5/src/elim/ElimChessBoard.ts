import { BaseClass } from "../common/BaseClass"
import { table } from "../common/table"
import { MiniGameModel } from "../commonModel/MiniGameModel"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"
import { ElimBlock } from "./ElimBlock"
import { ElimBlockDisplay } from "./ElimBlockDisplay"
import { ElimCalc } from "./ElimCalc"
import { ElimChess } from "./ElimChess"
import { ElimChessDisplay } from "./ElimChessDisplay"
import { ElimChunk } from "./ElimChunk"
import { ElimDefine } from "./ElimDefine"
import { ElimGameMgr } from "./ElimGameMgr"
import { ElimRecord } from "./ElimRecord"
import { ElimUtil } from "./ElimUtil"


/**棋盘管理类 */
export class ElimChessBoard extends BaseClass {
    action_wave
    /**[[ElimBlock]] */
    blocks
    board_display

    /**{
        x_len: 8,               // 棋盘行
        y_len: 8,               // 列
        limit_num: 3,           // 生成至少多少个可消除
        block_width: 73,        // 棋子宽
        block_height: 73,       // 棋子高
        drag_limit_dis: 40,        // 拖动最小距离
        board_data,              //棋盘的布局
        buff_data,                  //buff数据
        score,                  //分数数据
    }*/
    context
    game_mgr: ElimGameMgr
    input_cmd
    result
    x_len
    y_len
    ActionCMD = ElimDefine.ActionCMD
    BlockDirection = ElimDefine.BlockDirection
    ChessType = ElimDefine.ChessType
    BlockType = ElimDefine.BlockType
    ChessBuffType = ElimDefine.ChessBuffType
    ELIM_LIMIT_NUM = ElimDefine.ELIM_LIMIT_NUM
    record: ElimRecord
    calc: ElimCalc
    mini_game_model: MiniGameModel

    //当前调换源目标
    op_pos
    tp_pos

    public constructor(context?) {
        super()

        this.context = context
        this.record = new ElimRecord()
        this.calc = new ElimCalc()
        this.mini_game_model = MiniGameModel.GetInstance()
        this.result = null
        this.action_wave = 1
        // actionQueue
    }

    /*
        初始化棋盘
    */
    public Init() {

        if (!this.context) {
            Message.show("缺少数据")
            return
        }
        if (!this.board_display) {
            //error("缺少表现")
        }
        this.InitBoard()


        this.game_mgr.Bind(ElimDefine.ElimEvent.ALL_CHESS_FALL_IN_OVER, () => {
            this.ContinueElim()
        })


        this.game_mgr.Bind(ElimDefine.ElimEvent.CHUNK_CHESS_WAIT_DEAL_OVER, () => {
            this.EliminateAllChunksTemp()
        })


        this.game_mgr.Bind(ElimDefine.ElimEvent.ELIM_RESET_BOARD, () => {
            this.record.Clean()
            ElimGameMgr.GetInstance().ClearAction()
            this.calc.SetTotalScore(0)
            this.ResetChessBoard()
        })

    }

    public DeleteMe() {

        super.DeleteMe()
    }

    public InitBoard() {

        this.game_mgr = ElimGameMgr.GetInstance()
        let x_len = this.context.x_len
        let y_len = this.context.y_len
        let board_data = this.context.board_data
        let board_blocks = this.game_mgr.GetBoardGen().Map2ChessBoard()

        this.x_len = x_len
        this.y_len = y_len

        if (this.context.score) {
            this.calc.SetTotalScore(this.context.score)
        }

        this.blocks = board_blocks

        this.AddAction(this.ActionCMD.INIT_BOARD, this.context)
        this.game_mgr.GetBoardGen().OnInitBoard()

        if (ElimDefine.UseTestMap) {
            //this:Action()

            //let board_gen = this.game_mgr.GetBoardGen()
            //let num, group_list = board_gen.CheckNewElimGroup(100)
            //if (num < 1 ) {
            //    //this:ResetChessBoard()
            //}
        }
    }

    public Shuffle() {
        let action_list = this.game_mgr.GetBoardGen().ShuffleGenNewBoard()
        this.AddAction(this.ActionCMD.SHUFFLE, action_list)
    }

    public ResetChessBoard() {

        let [board_data, buff_data] = this.game_mgr.GetBoardGen().ResetChessBoard()
        this.AddAction(this.ActionCMD.RESET, board_data, buff_data)
    }

    public SetBoardDisplay(board_display?) {

        this.board_display = board_display
    }

    public AddAction(action_id, ...new_args) {

        this.record.AddAction(action_id, ...new_args)
    }

    // TODO
    public AddChess(chess_type?, pos?, buff_type?) {

        if (!this.blocks) {
            return false
        }
        //egret.log("_______________addchess")
        //PrintTable(pos)
        let block = this.blocks[pos[0]][pos[1]]
        if (block) {
            if (!block.HasChess()) {
                block.SetChess(new ElimChess(chess_type, buff_type))
                return true
            } else {
                Message.show("已经存在棋子")
            }
        }
        return false
    }



    public CheckResult() {

        this.result = false
    }

    public SwapChess(source_pos?, target_pos?) {

        let s_block: ElimBlock = this.blocks[source_pos[0]][source_pos[1]]
        let t_block: ElimBlock = this.blocks[target_pos[0]][target_pos[1]]

        let s_chess = s_block.ReplaceChess(t_block.GetChess())
        t_block.SetChess(s_chess)

        //this:AddAction(this.ActionCMD.SWAP, true, source_pos, target_pos)
    }


    public ChangeChess(x?, y?, buff_type?, chess_type?) {

        if (!this.blocks) {
            return false
        }
        let block: ElimBlock = this.blocks[x][y]
        if (block) {
            let chess = block.GetChess()
            block.SetChess(new ElimChess(chess_type, buff_type))
        }
    }

    /*
        op_pos: 交换的动作
    */
    public SwapAfterAction(op_pos?, tp_pos?) {

        //游戏结束不能交换
        if (this.mini_game_model.is_end) {
            return
        }
        this.Action(op_pos, tp_pos)
    }

    public Action(op_pos?, tp_pos?) {

        this.OnBeforeAction()
        //修改后
        this.op_pos = op_pos
        this.tp_pos = tp_pos
        let chunks = this.CheckAllChunk(op_pos, tp_pos)
        if (chunks.length > 0) {
            // 触发集合的消除策略  EliminateAllChunks——>FallInAndGenChunk——>ContinueElim
            this.EliminateAllChunks(chunks)
        } else {
            this.OnAfterAction()
        }
    }


    /***
     * 进行下一步消除动作
     */
    private ContinueElim() {
        let chunks = this.CheckAllChunk()
        this.action_wave = this.action_wave + 1    //this.action_wave 用来计算  消除回合下落速度   ActionWave2Spd
        if (chunks.length > 0) {
            // 触发集合的消除策略
            this.EliminateAllChunks(chunks)
        } else {
            this.OnAfterAction()
        }
    }

    public OnBeforeAction() {
        ElimGameMgr.GetInstance().is_eliming = true
        this.calc.OnBeforeAction()
        this.action_wave = 0
    }

    public OnAfterAction() {
        ElimGameMgr.GetInstance().is_eliming = false
        let board_gen = this.game_mgr.GetBoardGen()
        board_gen.OnAfterAction()

        let [num, group_list] = board_gen.CheckNewElimGroup(1)
        if (num < 1) {
            this.Shuffle()
        }
        this.action_wave = 0
    }

    public GetAllBuff(except_buff?) {

        let buff_list = []
        let block
        for (let i = 0; i < this.x_len; i++) {
            for (let j = 0; j < this.y_len; j++) {
                block = this.blocks[i][j]
                if (block.HasBuff()) {
                    if (except_buff) {
                        if (block.GetBuffType() != except_buff) {
                            table.insert(buff_list, block)
                        }
                    } else {
                        table.insert(buff_list, block)
                    }
                }
            }
        }
        return buff_list
    }


    /**获取到一个旗子 */
    public GetChessByBoard(x, y): ElimBlock {
        return this.blocks[x][y]
    }

    public OnBeforeBonusTime() {

        this.AddAction(this.ActionCMD.BONUS_TIME_BEGIN)
    }

    public OnAfterBonusTime() {

        this.input_cmd = {
            source_pos: [
                0, 0
            ],
            dir: [
                0, 0
            ]
        }
        let board_gen = this.game_mgr.GetBoardGen()
        board_gen.OnAfterBonusTime()
        this.AddAction(this.ActionCMD.BONUS_TIME_END)
    }

    public StartBonusTime() {

        let buff_list = this.GetAllBuff(this.ChessBuffType.Score)
        if (!buff_list || (!(Util.TableSize(buff_list) > 0))) {
            // } bonus time
            return
        }

        this.OnBeforeBonusTime()
        let chunks = []
        while (Util.TableSize(buff_list) > 0 || Util.TableSize(chunks) > 0) {
            if (Util.TableSize(buff_list) > 0) {
                this.TriggerBuff(buff_list)
                this.FallInAndGenChunk()
            }
            chunks = this.CheckAllChunk()
            if (Util.TableSize(chunks) > 0) {
                this.EliminateAllChunks(chunks)
                this.FallInAndGenChunk()
            }
            buff_list = this.GetAllBuff(this.ChessBuffType.Score)
        }
        this.OnAfterBonusTime()
    }

    public TriggerBuff(buff_list?) {

        if (!buff_list) {
            return
        }
        if (!(Util.TableSize(buff_list) > 0)) {
            return
        }
        let chess_type = null
        for (let _ = 0; _ < buff_list.length; _++) {
            var block = buff_list[_]
            chess_type = null
            if (block.GetBuffType() == this.ChessBuffType.Star) {
                chess_type = Util.RandomRange(1, 5)
            }
            block.TriggerBuff(chess_type)
        }
    }

    /**把已经存在的棋子往下挪，并生成一些新的填补位置，（这一步会包含一些消除动作，类似以旧换新） */
    public FallInAndGenChunk() {

        if (!this.blocks) {
            return
        }


        // 下落
        let fallin_list = []
        let null_row = 0
        let fallin_data = []
        // 从底下开始检查
        for (let i = 0; i < this.y_len; i++) {
            null_row = 0
            for (let j = this.x_len - 1; j >= 0; j--) {
                let tmp_block: ElimBlock = this.blocks[j][i]
                if (!tmp_block.HasChess()) {
                    null_row = null_row + 1
                } else {
                    if (null_row > 0) {
                        let new_row = j + null_row
                        let source_block = this.blocks[j][i]
                        let target_block = this.blocks[new_row][i]

                        target_block.SetChess(source_block.GetChess())
                        source_block.SetChess(null)

                        table.insert(fallin_data, { source: [j, i], target: [new_row, i] })
                    }
                }
            }
            fallin_list[i] = null_row
        }
        // 生成
        let tmp_block
        let tmp_list = []
        for (let i = 0; i < this.y_len; i++) {

            for (let j = fallin_list[i] - 1; j >= 0; j--) {
                let y = j
                //egret.log("create: ", (y + "_" + i))
                tmp_block = this.blocks[y][i]
                if (!tmp_block.HasChess()) {
                    // TODO 需要按照权重随机生成
                    let chess = this.game_mgr.GetBoardGen().GenRandomChess()
                    tmp_block.AddChess(chess)
                    table.insert(tmp_list, [[y, i],
                    [-(fallin_list[i] - j), i],
                    chess.chess_type,
                    chess.GetBuffType(),
                    chess.GetBuffValue(),
                    ])
                }
            }
        }
        this.AddAction(this.ActionCMD.FALL_IN, fallin_data, tmp_list, this.action_wave)
    }
    

    cur_chunks: Array<ElimChunk> = [] //当前消除的步骤
    public EliminateAllChunks(chunks?) {

        if (chunks && Util.TableSize(chunks) > 0) {
            this.cur_chunks = chunks
            this.EliminateAllChunksTemp()
        }
    }

    wait_chunk = null
    /**分步处理 */
    private EliminateAllChunksTemp() {
        var chunk: ElimChunk
        if (this.wait_chunk) {
            chunk = this.wait_chunk
        } else {
            chunk = this.cur_chunks.shift()
        }

        if(!chunk)return

        //需要等彩蛋做出处理效果后 再进行下一步消除
        if ((chunk.chunk_type == ElimDefine.ChunkType.ElimSwapStar
            || chunk.chunk_type == ElimDefine.ChunkType.ElimStar)
            && this.wait_chunk == null
            && (this.GetChessType(this.op_pos) == this.ChessType.ColorStar || this.GetChessType(this.tp_pos) == this.ChessType.ColorStar)) {
            this.wait_chunk = chunk
            chunk.DealWithStar(this.op_pos, this.tp_pos)
        } else {
            this.wait_chunk = null

            //游戏结束
            if (this.mini_game_model.is_end) {
                return
            }


            //开始消除
            chunk.Eliminate(this.op_pos, this.tp_pos, () => {
                //填补
                this.FallInAndGenChunk()

                //下一步
                if (this.cur_chunks && Util.TableSize(this.cur_chunks) > 0) {
                    this.EliminateAllChunksTemp()
                }
            })

        }
    }




    /**消除方法 
     * @param block_list 消除成员列表
     * 
     */
    public EliminateChunk(block_list?) {

        if (!block_list || !this.blocks) {
            return
        }
        let tmp_block: ElimBlock
        for (let _ = 0; _ < block_list.length; _++) {
            var block_pos = block_list[_]
            tmp_block = this.blocks[block_pos[0]][block_pos[1]]
            if (tmp_block) {
                tmp_block.RemoveChess()

            }
        }
        this.calc.OnEliminateChunk(block_list)

    }

    public OnTriggerBuff(buff?, x?, y?) {

        this.calc.OnTriggerBuff(buff, x, y)
    }

    public FindRow(col?) {

        if (!this.blocks) {
            return null
        }

        let list = []
        for (let i = 0; i < this.y_len; i++) {
            if (this.BlockIsValid(col, i)) {
                table.insert(list, [col, i])
            }
        }
        return list
    }

    public FindCol(row?) {

        if (!this.blocks) {
            return null
        }

        let list = []
        for (let i = 0; i < this.x_len; i++) {
            if (this.BlockIsValid(i, row)) {
                table.insert(list, [i, row])
            }
        }
        return list
    }

    CircleDirection = [[- 1, 1], [0, 1], [1, 1],
    [-1, 0], [0, 0], [1, 0],
    [-1, -1], [0, -1], [1, -1],
    ]
    public FindCircle(x?, y?) {

        if (!this.SimpleCheckBlockIsValid(x, y)) {
            return null
        }
        let list = []
        let tmp_x, tmp_y
        for (let i = 0; i < this.CircleDirection.length; i++) {
            tmp_x = x + this.CircleDirection[i][0]
            tmp_y = y + this.CircleDirection[i][1]
            if (this.SimpleCheckBlockIsValid(tmp_x, tmp_y)) {
                table.insert(list, [tmp_x, tmp_y])
            }
        }
        return list
    }

    public FindStar(chess_type?) {

        let list = []
        for (let i = 0; i < this.x_len; i++) {
            for (let j = 0; j < this.y_len; j++) {
                let ct = this.blocks[i][j].GetChessType()
                if (ct && ct == chess_type && ct != this.ChessType.ColorStar) {
                    table.insert(list, [i, j])
                }
            }
        }
        return list
    }

    public CheckAllChunk(op_pos?, tp_pos?) {

        if (!this.blocks) {
            return
        }


        //游戏结束
        if (this.mini_game_model.is_end) {
            return []
        }

        let close_map = []
        let find_map = []
        let chunks: Array<ElimChunk> = []

        //彩蛋检查>基本检查>横竖圆互消

        //彩蛋检查
        if (op_pos && tp_pos) {
            //彩蛋互换  还有一种是彩蛋被其他特效消除，这个在LookingForColorLeg
            let can_swap = this.CheckSpecChessByPos(op_pos[0], op_pos[1], tp_pos[0], tp_pos[1])
            if (can_swap) {
                let chunk = new ElimChunk([op_pos, tp_pos], this)
                table.insert(chunks, chunk)
            }
        }


        // 基本检查
        for (let i = this.x_len - 1; i >= 0; i--) {
            for (let j = 0; j < this.y_len; j++) {
                if (!close_map[ElimUtil.TransformKey(i, j)] && !find_map[ElimUtil.TransformKey(i, j)]) {
                    let chunk = this.FindChunk(i, j, close_map, find_map)
                    if (chunk && chunk.IsValid()) {
                        table.insert(chunks, chunk)
                    } else {
                    }
                }
            }
        }


        //横竖圆互消
        if (op_pos && tp_pos) {
            let can_swap = this.CheckDirSpecChessByPos(op_pos[0], op_pos[1], tp_pos[0], tp_pos[1])
            if (can_swap) {
                let chunk = new ElimChunk([op_pos, tp_pos], this)
                table.insert(chunks, chunk)
            }
        }

        return chunks
    }

    /*
        close表的key由x*10000+y组成
    */
    public FindChunk(x?, y?, close_map?, find_map?) {

        if (!this.BlockIsValid(x, y)) {
            return null
        }

        if (close_map[ElimUtil.TransformKey(x, y)]) {
            return null
        }

        let cur_chess_type = this.blocks[x][y].GetChessType()
        let tmp_x = x
        let tmp_y = y
        let tmp_block
        let direction
        let block_list = []
        //table.insert(block_list, {x, y})
        let loop_num = 0
        let open_list = []
        table.insert(open_list, [x, y])
        while ((open_list.length > 0)) {
            let pos = open_list[0]
            let pos_x = pos[0]
            let pos_y = pos[1]
            loop_num = loop_num + 1
            if (!find_map[ElimUtil.TransformKey(pos_x, pos_y)]) {
                find_map[ElimUtil.TransformKey(pos_x, pos_y)] = true
                for (let i = 0; i < Util.TableSize(this.BlockDirection); i++) {
                    direction = this.BlockDirection[i]
                    tmp_x = pos_x + direction[0]
                    tmp_y = pos_y + direction[1]

                    if (this.BlockIsValid(tmp_x, tmp_y)) {
                        tmp_block = this.blocks[tmp_x][tmp_y]
                        if (tmp_block && cur_chess_type && tmp_block.GetChessType() == cur_chess_type) {
                            table.insert(open_list, [tmp_x, tmp_y])
                            if (!close_map[ElimUtil.TransformKey(tmp_x, tmp_y)]) {
                                close_map[ElimUtil.TransformKey(tmp_x, tmp_y)] = true
                                table.insert(block_list, [tmp_x, tmp_y])
                            }
                        }
                    }
                }
            }
            table.remove(open_list, 0)
            //elim_str = elim_str + "   open_list: " + open_list.length + " loop_num: " + loop_num + " chess_type: " + cur_chess_type + " xy: " + x .. "," + y .. "\n"
        }

        if (block_list.length >= this.ELIM_LIMIT_NUM) {
            return new ElimChunk(block_list, this)
        }
        return null
    }

    /*
        查询最低符合条件的交互
    */
    public CheckAndSwap(source_pos?, target_pos?) {

        if (!this.blocks) {
            return false
        }

        let sx = source_pos[0]
        let sy = source_pos[1]
        if (!this.BlockIsValid(sx, sy)) {
            return false
        }

        let tx = target_pos[0]
        let ty = target_pos[1]
        if (!this.BlockIsValid(tx, ty)) {
            return false
        }

        let s_block = this.blocks[sx][sy]
        let t_block = this.blocks[tx][ty]
        this.SwapChess(source_pos, target_pos)

        // 特殊棋子
        let can_swap = this.CheckSpecChess(s_block, t_block)
        if (can_swap) {
            return true
        }

        //横竖圆&&横竖圆交换
        can_swap = this.CheckDirSpecChessByPos(sx, sy, tx, ty)
        if (can_swap) {
            return true
        }


        //常规的交换
        can_swap = this.CheckMultipleDirection(sx, sy, s_block.GetChessType())
        if (can_swap) {
            return true
        }
        can_swap = this.CheckMultipleDirection(tx, ty, t_block.GetChessType())
        if (can_swap) {
            return true
        }

        this.SwapChess(target_pos, source_pos)
        return false
    }

    public CheckSpecChessByPos(sx?, sy?, tx?, ty?) {

        let s_block = this.blocks[sx][sy]
        let t_block = this.blocks[tx][ty]
        if (!s_block || !t_block) {
            return false
        }
        return this.CheckSpecChess(s_block, t_block)
    }

    public CheckSpecChess(s_block?, t_block?) {

        if (!s_block.HasChess() || !t_block.HasChess()) {
            return false
        }
        let s_chess = s_block.GetChess()
        let t_chess = t_block.GetChess()
        if (!s_chess.HasBuff() && !t_chess.HasBuff()) {
            return false
        }
        //星星
        if (s_chess.GetBuffType() == this.ChessBuffType.Star || t_chess.GetBuffType() == this.ChessBuffType.Star) {
            return true
        }
        return false
    }

    /***横竖圆&&横竖圆 交换 */
    public CheckDirSpecChessByPos(sx?, sy?, tx?, ty?) {
        let s_block = this.blocks[sx][sy]
        let t_block = this.blocks[tx][ty]
        if (!s_block.HasChess() || !t_block.HasChess()) {
            return false
        }
        let s_chess = s_block.GetChess()
        let t_chess = t_block.GetChess()
        if (!s_chess.HasBuff() && !t_chess.HasBuff()) {
            return false
        }
        //星星
        let s_buff_type = s_chess.GetBuffType()
        let t_buff_type = t_chess.GetBuffType()

        let s_boo = s_buff_type == this.ChessBuffType.Row || s_buff_type == this.ChessBuffType.Col || s_buff_type == this.ChessBuffType.Circle
        let t_boo = t_buff_type == this.ChessBuffType.Row || t_buff_type == this.ChessBuffType.Col || t_buff_type == this.ChessBuffType.Circle

        if (s_boo && t_boo) {
            return true
        }
        return false
    }


    public CheckMultipleDirection(x?, y?, chess_type?) {

        let tmp_x = x
        let tmp_y = y

        let total_num = 1
        let result
        let same_num
        let a = this.CheckSingleDirection(tmp_x, tmp_y, this.BlockDirection[0], chess_type, true)
        result = a[0]
        same_num = a[1]
        if (result) {
            return true
        }
        total_num = total_num + same_num
        a = this.CheckSingleDirection(tmp_x, tmp_y, this.BlockDirection[1], chess_type, true)
        result = a[0]
        same_num = a[1]
        if (result || (total_num + same_num) >= this.ELIM_LIMIT_NUM) {
            return true
        }

        total_num = 1
        a = this.CheckSingleDirection(tmp_x, tmp_y, this.BlockDirection[2], chess_type, false)
        result = a[0]
        same_num = a[1]
        if (result) {
            return true
        }
        total_num = total_num + same_num
        a = this.CheckSingleDirection(tmp_x, tmp_y, this.BlockDirection[3], chess_type, false)
        result = a[0]
        same_num = a[1]
        if (result || (total_num + same_num) >= this.ELIM_LIMIT_NUM) {
            return true
        }

        return false
    }

    public CheckSingleDirection(x?, y?, direction?, chess_type?, is_x?) {

        let num = 0
        let tmp_block: ElimBlock
        if (is_x) {
            x = x + direction[0]
        } else {
            y = y + direction[1]
        }
        while (this.BlockIsValid(x, y) && num < this.ELIM_LIMIT_NUM) {
            tmp_block = this.blocks[x][y]
            if (tmp_block.GetChessType() == chess_type) {
                num = num + 1
                if (is_x) {
                    x = x + direction[0]
                } else {
                    y = y + direction[1]
                }
            } else {
                break
            }
        }
        if (num >= this.ELIM_LIMIT_NUM) {
            return [true, num]
        }
        return [false, num]
    }

    /**棋子风格 */
    public GetChessType(pos?) {

        if (!this.blocks || !pos) {
            return
        }
        if (!this.blocks[pos[0]] || !this.blocks[pos[0]][pos[1]]) {
            return
        }
        return this.blocks[pos[0]][pos[1]].GetChessType()
    }

    /**棋子特效类型 */
    public GetChessBuffType(pos?) {

        if (!this.blocks || !pos) {
            return
        }
        if (!this.blocks[pos[0]] || !this.blocks[pos[0]][pos[1]]) {
            return
        }
        return this.blocks[pos[0]][pos[1]].GetBuffType()
    }

    /**测试用 */
    public SetChessBuffTest(pos, buff, chess_type) {
        if (!this.blocks || !pos) {
            return
        }
        if (!this.blocks[pos[0]] || !this.blocks[pos[0]][pos[1]]) {
            return
        }

        let em: ElimBlock = this.blocks[pos[0]][pos[1]]
        let ct = chess_type == null ? em.GetChessType() : chess_type
        em.ReplaceChess(new ElimChess(ct, buff))
    }

    /**
     * 找到同样颜色的消除
     * @param pos  位置颜色
     * @param is_all_color  是否全部颜色
     * @returns 
     */
    public FindAllSameColor(pos?, is_all_color?) {
        let list = []
        if (!this.blocks || !pos) {
            return list
        }
        if (!this.blocks[pos[0]] || !this.blocks[pos[0]][pos[1]]) {
            return list
        }
        let block = this.blocks[pos[0]][pos[1]]
        if (block) {
            let chess_type = block.GetChessType()
            if (chess_type != this.BlockType.None) {
                for (let i = 0; i < this.x_len; i++) {
                    for (let j = 0; j < this.y_len; j++) {

                        if (this.GetChessType([i, j]) == ElimDefine.ChessType.ColorStar) {
                            continue
                        }
                        let tmp_block: ElimBlock = this.blocks[i][j]
                        if (!is_all_color) {
                            if (tmp_block && tmp_block.GetChessType() == chess_type) {
                                table.insert(list, [i, j])
                            }
                        } else {
                            table.insert(list, [i, j])
                        }

                    }
                }
            }
        }
        return list
    }

    public SimpleCheckBlockIsValid(x?, y?) {

        if (!this.blocks) {
            return false
        }

        if (x < 0 || x > (this.x_len - 1) || y < 0 || y > (this.y_len - 1)) {
            return false
        }
        if (!this.blocks[x][y]) {
            return false
        }
        return true
    }

    public BlockIsValid(x?, y?) {

        let valid = this.SimpleCheckBlockIsValid(x, y)
        if (!valid) {
            return false
        }

        let e_block: ElimBlock = this.blocks[x][y]
        if (!e_block.HasChess()) {
            return false
        }

        return true
    }

    public InputAction(input_cmd?) {

        if (this.result) {
            return
        }

        this.InputSwap(input_cmd)
    }

    public InputSwap(input_cmd?) {

        this.input_cmd = input_cmd

        let source_pos = input_cmd.source_pos
        let target_pos = input_cmd.target_pos

        let source_info, target_info
        let is_legal = this.CheckAndSwap(source_pos, target_pos)
        if (is_legal) {
            //合法允许的  可以调换
            this.AddAction(this.ActionCMD.SWAP, true, source_pos, target_pos)
            this.SwapAfterAction(target_pos, source_pos)
        } else {
            this.input_cmd = null
            this.AddAction(this.ActionCMD.SWAP, false, source_pos, target_pos)
            //Message.show("不能移动")
        }
    }
}