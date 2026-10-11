import { BaseClass } from "../common/BaseClass"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { ElimBlock } from "./ElimBlock"
import { ElimBlockDisplay } from "./ElimBlockDisplay"
import { ElimChessDisplay } from "./ElimChessDisplay"
import { ElimDefine } from "./ElimDefine"
import { ElimGameMgr } from "./ElimGameMgr"

/**旗子特效管理类 */
export class ElimChessBuff extends BaseClass {
    buff_type
    value
    public ChessBuffType = ElimDefine.ChessBuffType
    public ActionCMD = ElimDefine.ActionCMD

    public constructor(buff_type?) {
        super()

        this.buff_type = buff_type
    }

    public SetParam(value?) {

        this.value = value
    }

    /**找到一行并消除 */
    public TriggerRow = (x, y) => {
        let board = ElimGameMgr.GetInstance().chess_board
        let list = board.FindRow(x)
        if (list && Util.TableSize(list) > 0) {

            let ne_list = this.LookingForColorLeg(list)
            list = list.concat(ne_list)

            board.EliminateChunk(list)
            return list
        }
        return []
    }

    /**找到一列并消除 */
    public TriggerCol = (x, y) => {
        let board = ElimGameMgr.GetInstance().chess_board
        let list = board.FindCol(y)
        if (list && Util.TableSize(list) > 0) {

            let ne_list = this.LookingForColorLeg(list)
            list = list.concat(ne_list)

            board.EliminateChunk(list)
            return list
        }

        return []
    }

    /**找到周围一圈并消除 */
    public TriggerCircle = (x, y) => {
        let board = ElimGameMgr.GetInstance().chess_board
        let list = board.FindCircle(x, y)
        if (list && Util.TableSize(list) > 0) {

            let ne_list = this.LookingForColorLeg(list)
            list = list.concat(ne_list)


            board.EliminateChunk(list)
            return list
        }
        return []
    }

    /**找到同样类型的并消除 
     * 
     * @param is_not_elim  true不进行消除动作  false消除
    */
    public TriggerStar = (x, y, chess_type,is_not_elim?) => {
        let board = ElimGameMgr.GetInstance().chess_board
        let list = board.FindStar(chess_type)
        if (list && Util.TableSize(list) > 0) {
            table.insert(list, [x, y])

            if(!is_not_elim){
                board.EliminateChunk(list)
            }
            return list
        }
        return []
    }

    /** 彩蛋在其他buff棋子的消除范围之内  因为源目标已经被消除掉，调用这份消除名单的时候
     * 会找不到源目标的棋子颜色，所以彩蛋在上下左右方向找个幸运棋子消除
     * @param list 消除目录
    */
    private LookingForColorLeg(list) {
        let list_temp = []
        let board = ElimGameMgr.GetInstance().chess_board
        for (let i = 0; i < list.length; i++) {
            let pos_vo = list[i]
            if (board.GetChessType(pos_vo) == ElimDefine.ChessType.ColorStar) {

                let CircleDirection = [
                    [-1, 0],
                    [0, -1],
                    [0, 1],
                    [1, 0]
                ]

                let t_chess_list = []
                for (let ct = 0; ct < CircleDirection.length; ct++) {
                    let tmp_x = pos_vo[0] + CircleDirection[ct][0]
                    let tmp_y = pos_vo[1] + CircleDirection[ct][1]

                    let chess_type = board.GetChessType([tmp_x, tmp_y])
                    if (chess_type > 0 && chess_type != ElimDefine.ChessType.ColorStar) {
                        t_chess_list.push([tmp_x, tmp_y,chess_type])
                    }
                }

                if (t_chess_list.length > 0) {
                    let r_index = Util.RandomRange(0, t_chess_list.length - 1)
                    let data = t_chess_list[r_index]

                    this.TriggerStarButNotElim(data[0], data[1], data[2])
                    list_temp = this.TriggerStar(data[0], data[1], data[2],true)
                }

            }
        }
        return list_temp
    }

    /**找到同样类型的旗子 并做一些处理 */
    public TriggerStarButNotElim = (x, y, chess_type) => {
        let board = ElimGameMgr.GetInstance().chess_board
        let list = board.FindStar(chess_type)
        table.insert(list, [x, y])//这个是吞噬目标的坐标
        if (list && Util.TableSize(list) > 0) {
            for (let i = 0; i < list.length; i++) {
                let block_dis: ElimBlockDisplay = ElimGameMgr.GetInstance().GetBlock([list[i][0], list[i][1]])
                if (block_dis) {
                    let chess: ElimChessDisplay = block_dis.GetChess();
                    if (chess) {
                        chess.ScaleBig(true);
                    }
                }
            }
        }
    }


    public TriggerScore = (x, y, chess_type) => {
        // Do Nothing
    }

    BuffTye2Func = {
        [this.ChessBuffType.Row]: this.TriggerRow,
        [this.ChessBuffType.Col]: this.TriggerCol,
        [this.ChessBuffType.Circle]: this.TriggerCircle,
        [this.ChessBuffType.Star]: this.TriggerStar,
        [this.ChessBuffType.Score]: this.TriggerScore,
    }

    /***触发buff消除 */
    public TriggerFunc = (x, y, chess_type) => {

        //特效播放
        let time_out = ElimGameMgr.GetInstance().GetEffPlayTime(this.buff_type,true)
        if (time_out > 0) {
            setTimeout(() => {
                ElimGameMgr.GetInstance().Fire(ElimDefine.ElimEvent.FIRE_BLOCK_EFFECT, x, y, this.buff_type)
            }, time_out);
        }

        if (this.BuffTye2Func[this.buff_type]) {
            this.BuffTye2Func[this.buff_type](x, y, chess_type)
        }
    }

    /**
     * 
     * @param x 行
     * @param y 列
     * @param chess_type 棋子外观类型
     */
    public TriggerBuff(x?, y?, chess_type?) {

        this.TriggerFunc(x, y, chess_type)
        let board = ElimGameMgr.GetInstance().chess_board
        board.OnTriggerBuff(this, x, y,)
    }

}