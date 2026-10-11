import { BaseClass } from "../common/BaseClass"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { ElimChessBoard } from "./ElimChessBoard"
import { ElimDefine } from "./ElimDefine"
import { ElimGameMgr } from "./ElimGameMgr"
import { ElimUtil } from "./ElimUtil"


export class ElimChunk extends BaseClass {
    axis_direction
    block_list
    chunk_type
    elim_board: ElimChessBoard
    ChunkType = ElimDefine.ChunkType
    ChessType = ElimDefine.ChessType
    ChessBuffType = ElimDefine.ChessBuffType
    ActionCMD = ElimDefine.ActionCMD
    AxisDirection = ElimDefine.AxisDirection
    ELIM_LIMIT_NUM = ElimDefine.ELIM_LIMIT_NUM


    call_back_cache = null
    time_id_
    public constructor(block_list?, elim_board?) {
        super()

        this.block_list = block_list
        this.elim_board = elim_board
        this.axis_direction = null
        this.AnalyzeAndWeedOut()
    }

    public CheckElimThree = () => {
        if (!this.block_list || this.block_list.length < this.ELIM_LIMIT_NUM) {
            return this.ChunkType.None
        }
        let xlist, ylist
        let a = ElimUtil.CheckDirectionPosList(this.block_list, this.AxisDirection.X, 3)
        let check_ret = a[0]
        xlist = a[1]
        if (check_ret) {
            this.block_list = xlist
            this.axis_direction = this.AxisDirection.X
            return this.ChunkType.ElimThree
        }
        a = ElimUtil.CheckDirectionPosList(this.block_list, this.AxisDirection.Y, 3)
        check_ret = a[0]
        ylist = a[1]
        if (check_ret) {
            this.block_list = ylist
            this.axis_direction = this.AxisDirection.Y
            return this.ChunkType.ElimThree
        }
        return this.ChunkType.None
    }

    public CheckElimXFour = () => {
        if (!this.block_list || this.block_list.length < 4) {
            return this.ChunkType.None
        }
        let [check_ret, xlist] = ElimUtil.CheckDirectionPosList(this.block_list, this.AxisDirection.X, 4)
        if (check_ret) {
            this.block_list = xlist
            this.axis_direction = this.AxisDirection.X
            return this.ChunkType.ElimXFour
        }
        return this.ChunkType.None
    }

    public CheckElimYFour = () => {
        if (!this.block_list || this.block_list.length < 4) {
            return this.ChunkType.None
        }
        let [check_ret, ylist] = ElimUtil.CheckDirectionPosList(this.block_list, this.AxisDirection.Y, 4)
        if (check_ret) {
            this.block_list = ylist
            this.axis_direction = this.AxisDirection.Y
            return this.ChunkType.ElimYFour
        }
        return this.ChunkType.None
    }

    public CheckElimCircle = () => {
        if (!this.block_list || this.block_list.length < 5) {
            return this.ChunkType.None
        }
        let [check_ret, xlist] = ElimUtil.CheckDirectionPosList(this.block_list, this.AxisDirection.X, 3)
        let [check_ret2, ylist] = ElimUtil.CheckDirectionPosList(this.block_list, this.AxisDirection.Y, 3)
        if (check_ret && check_ret2) {
            this.block_list = ElimUtil.MergeList(xlist, ylist)
            return this.ChunkType.ElimCircle
        }
        return this.ChunkType.None
    }

    public CheckElimStar = () => {
        if (!this.block_list || this.block_list.length < 5) {
            return this.ChunkType.None
        }
        let xlist, ylist
        let a = ElimUtil.CheckDirectionPosList(this.block_list, this.AxisDirection.X, 5)
        let check_ret = a[0]
        xlist = a[1]
        if (check_ret) {
            this.block_list = xlist
            this.axis_direction = this.AxisDirection.X
            return this.ChunkType.ElimStar
        }
        a = ElimUtil.CheckDirectionPosList(this.block_list, this.AxisDirection.Y, 5)
        check_ret = a[0]
        ylist = a[1]

        if (check_ret) {
            this.block_list = ylist
            this.axis_direction = this.AxisDirection.Y
            return this.ChunkType.ElimStar
        }
        return this.ChunkType.None
    }

    public CheckElimSwapStar = () => {
        if (!this.block_list || this.block_list.length != 2) {
            return this.ChunkType.None
        }
        let op_pos = this.block_list[0]
        let tp_pos = this.block_list[1]
        // TODO 暂时只有1种特殊棋子检测
        let can_swap = this.elim_board.CheckSpecChessByPos(op_pos[0], op_pos[1], tp_pos[0], tp_pos[1])
        if (can_swap) {
            return this.ChunkType.ElimSwapStar
        }
        return this.ChunkType.None
    }


    /**横竖圆&横竖圆互消除 */
    public CheckElimSwapBuff = () => {
        if (!this.block_list || this.block_list.length != 2) {
            return this.ChunkType.None
        }
        let op_pos = this.block_list[0]
        let tp_pos = this.block_list[1]
        let can_swap = this.elim_board.CheckDirSpecChessByPos(op_pos[0], op_pos[1], tp_pos[0], tp_pos[1])
        if (can_swap) {
            return this.ChunkType.ElimSwapBuff
        }
        return this.ChunkType.None
    }

    ChunkType2CheckFunc = {
        [this.ChunkType.ElimThree]: this.CheckElimThree,
        [this.ChunkType.ElimXFour]: this.CheckElimXFour,
        [this.ChunkType.ElimYFour]: this.CheckElimYFour,
        [this.ChunkType.ElimCircle]: this.CheckElimCircle,
        [this.ChunkType.ElimStar]: this.CheckElimStar,
        [this.ChunkType.ElimSwapStar]: this.CheckElimSwapStar,
        [this.ChunkType.ElimSwapBuff]: this.CheckElimSwapBuff,
    }

    public AnalyzeAndWeedOutFunc = () => {
        //let block_list = this.block_list

        for (let chunk_type = this.ChunkType.ElimSwapBuff; chunk_type >= this.ChunkType.ElimThree; chunk_type -= 1) {
            if (this.ChunkType2CheckFunc[chunk_type]) {
                this.chunk_type = this.ChunkType2CheckFunc[chunk_type]()
                if (this.chunk_type != this.ChunkType.None) {
                    break
                }
            }
        }
    }

    public AnalyzeAndWeedOut() {

        this.chunk_type = this.ChunkType.None
        if (!this.block_list) {
            return
        }
        this.AnalyzeAndWeedOutFunc()
    }


    //////////////////////////////////////////////////////////////

    public GetGenPos = (op_pos, tp_pos, block_list) => {
        for (let _ = 0; _ < block_list.length; _++) {
            let pos = block_list[_]
            if (op_pos) {
                if (pos[0] == op_pos[0] && pos[1] == op_pos[1]) {
                    return op_pos
                }
            }
            if (tp_pos) {
                if (pos[0] == tp_pos[0] && pos[1] == tp_pos[1]) {
                    return tp_pos
                }
            }
        }
        return null
    }

    public EliminateElimThree = () => {
        this.elim_board.EliminateChunk(this.block_list)
        this.elim_board.AddAction(this.ActionCMD.ELIM, this.block_list)
    }

    public EliminateElimXFour = (op_pos, tp_pos) => {
        let buff_type = this.GetBuffTypeByDir(this.ChessBuffType.Row)
        let new_pos = this.GetGenPos(op_pos, tp_pos, this.block_list)
        if (!new_pos) {
            let index = Util.RandomRange(0, this.block_list.length - 1)
            new_pos = this.block_list[index]
        }
        if (!new_pos) {
        }

        let new_chess_type = this.elim_board.blocks[new_pos[0]][new_pos[1]].GetChessType()
        this.elim_board.EliminateChunk(this.block_list)
        this.elim_board.AddAction(this.ActionCMD.ELIM, this.block_list)

        //生成新的特效棋子
        if (new_pos) {
            this.AddChess(new_chess_type, new_pos, buff_type)
        }
    }

    public EliminateElimYFour = (op_pos, tp_pos) => {
        let buff_type = this.GetBuffTypeByDir(this.ChessBuffType.Col)
        let new_pos = this.GetGenPos(op_pos, tp_pos, this.block_list)
        if (!new_pos) {
            new_pos = ElimUtil.FindYFourPos(this.block_list)
        }

        let new_chess_type = this.elim_board.blocks[new_pos[0]][new_pos[1]].GetChessType()
        this.elim_board.EliminateChunk(this.block_list)
        this.elim_board.AddAction(this.ActionCMD.ELIM, this.block_list)

        // TODO 生成特殊棋子

        if (new_pos) {
            this.AddChess(new_chess_type, new_pos, buff_type)
        }
    }

    public EliminateElimCircle = (op_pos, tp_pos) => {
        let new_pos = this.GetGenPos(op_pos, tp_pos, this.block_list)
        if (!new_pos) {
            new_pos = ElimUtil.FindCircleIntersectPos(this.block_list)
        }

        if (!new_pos) {
            new_pos = this.block_list[0]
        }

        let new_chess_type = this.elim_board.blocks[new_pos[0]][new_pos[1]].GetChessType()
        this.elim_board.EliminateChunk(this.block_list)
        this.elim_board.AddAction(this.ActionCMD.ELIM, this.block_list)

        if (new_pos) {
            this.AddChess(new_chess_type, new_pos, this.ChessBuffType.Circle)
        }
    }

    /***生成彩蛋*/
    public EliminateElimStar = (op_pos, tp_pos) => {
        let axis = this.axis_direction
        // 1、找到特殊棋子位置
        let center_pos = ElimUtil.FindCenterPos(this.block_list, axis)
        if (!center_pos) {
            return
        }
        // 2、消除棋子并触发buff
        this.elim_board.EliminateChunk(this.block_list)
        this.elim_board.AddAction(this.ActionCMD.ELIM, this.block_list)

        // 3、生成棋子
        this.AddChess(this.ChessType.ColorStar, center_pos, this.ChessBuffType.Star)
    }


    /**彩蛋互换 */
    public EliminateElimSwapStar = (op_pos, tp_pos) => {

        let list
        let tmp_pos = tp_pos
        if (this.elim_board.GetChessType(op_pos) != this.ChessType.ColorStar) {
            tmp_pos = op_pos
            list = this.elim_board.FindAllSameColor(tmp_pos)
        } else if (this.elim_board.GetChessType(tp_pos) != this.ChessType.ColorStar) {
            tmp_pos = tp_pos
            list = this.elim_board.FindAllSameColor(tmp_pos)
        } else {
            //两个彩蛋
            list = this.elim_board.FindAllSameColor(tmp_pos, true)
        }


        this.block_list = this.block_list.concat(list)
        // 2、消除棋子并触发buff
        this.elim_board.EliminateChunk(this.block_list)
        this.elim_board.AddAction(this.ActionCMD.ELIM, this.block_list)

    }

    /**横竖圆互消 */
    public EliminateElimSwapBuff = (op_pos, tp_pos) => {
        //消除棋子并触发buff
        this.elim_board.EliminateChunk(this.block_list)
        this.elim_board.AddAction(this.ActionCMD.ELIM, this.block_list)

    }




    ChunkTye2EliminateFunc = {
        [this.ChunkType.ElimThree]: this.EliminateElimThree,
        [this.ChunkType.ElimXFour]: this.EliminateElimXFour,
        [this.ChunkType.ElimYFour]: this.EliminateElimYFour,
        [this.ChunkType.ElimCircle]: this.EliminateElimCircle,
        [this.ChunkType.ElimStar]: this.EliminateElimStar,
        [this.ChunkType.ElimSwapStar]: this.EliminateElimSwapStar,
        [this.ChunkType.ElimSwapBuff]: this.EliminateElimSwapBuff
    }

    public EliminateFunc = (op_pos, tp_pos) => {


        if (this.chunk_type == this.ChunkType.None || !this.block_list || !this.elim_board) {
            return
        }
        if (this.ChunkTye2EliminateFunc[this.chunk_type]) {
            this.ChunkTye2EliminateFunc[this.chunk_type](op_pos, tp_pos)
        }

        //下一步进行
        if (this.call_back_cache) this.call_back_cache() 
    }

    /**处理彩蛋效果*/
    public DealWithStar = (op_pos, tp_pos) => {

        // 1、重新找到星星触发的需要消除的棋子
        let list
        if (this.elim_board.GetChessType(op_pos) != this.ChessType.ColorStar) {
            list = this.elim_board.FindAllSameColor(op_pos)
            list.push(tp_pos)
        } else if (this.elim_board.GetChessType(tp_pos) != this.ChessType.ColorStar) {
            list = this.elim_board.FindAllSameColor(tp_pos)
            list.push(op_pos)
        } else {
            //两个彩蛋
            list = this.elim_board.FindAllSameColor(tp_pos, true)
        }

        ElimGameMgr.GetInstance().need_deal_num = list.length
        for (let i = 0; i < list.length; i++) {
            ElimGameMgr.GetInstance().Fire(ElimDefine.ElimEvent.CHUNK_CHESS_WAIT_DEAL, list[i][0], list[i][1])
        }

    }

    /**
     * @param call_back 消除结束后调用
     */
    public Eliminate(op_pos?, tp_pos?, call_back?) {
   
        if (this.chunk_type == this.ChunkType.None) {
            return
        }
        this.call_back_cache = call_back
        if (!this.block_list) {
            return
        }
        this.EliminateFunc(op_pos, tp_pos)
    }

    public AddChess(chess_type?, new_pos?, buff_type?) {

        let is_add = this.elim_board.AddChess(chess_type, new_pos, buff_type)//留空
        if (is_add) {
            this.elim_board.AddAction(this.ActionCMD.GEN_SPECIAL, chess_type, new_pos, buff_type)//增加特殊棋子
        }
    }

    public IsValid() {

        return this.chunk_type != this.ChunkType.None
    }

    public GetBuffTypeByDir(default_type?) {

        let buff_type = default_type
        if (this.elim_board.input_cmd) {
            let dir = this.elim_board.input_cmd.dir
            let is_row = Math.abs(dir[1]) > 0
            if (is_row) {
                buff_type = this.ChessBuffType.Row
            } else {
                buff_type = this.ChessBuffType.Col
            }
        }
        return buff_type
    }
}