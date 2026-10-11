import { BaseClass } from "../common/BaseClass"
import { table } from "../common/table"
import { MiniGameModel } from "../commonModel/MiniGameModel"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"
import { ElimBlock } from "./ElimBlock"
import { ElimChess } from "./ElimChess"
import { ElimChessBuff } from "./ElimChessBuff"
import { ElimDefine } from "./ElimDefine"
import { ElimGameMgr } from "./ElimGameMgr"


/**棋局的生成和变动 */
export class ElimBoardGen extends BaseClass {
    chess_gen_rate_map
    elim_map
    init_buff_list
    limit_num
    mini_game_model: MiniGameModel
    score_buff_map
    tmp_elim_map
    x_len
    y_len
    public ChessType = ElimDefine.ChessType
    public ChessBuffType = ElimDefine.ChessBuffType
    public UseTestMap = ElimDefine.UseTestMap
    public MAX_COLOR = 5

    public constructor() {
        super()

        this.elim_map = []
        this.tmp_elim_map = []
        // buff
        this.init_buff_list = []
        // 积分
        this.score_buff_map = []
        this.mini_game_model = MiniGameModel.GetInstance()
    }

    public GenRandomChessArr = () => {
        let random_chess_arr = [
            this.ChessType.Color1,
            this.ChessType.Color2,
            this.ChessType.Color3,
            this.ChessType.Color4,
            this.ChessType.Color5
        ]
        for (let i = 0; i < random_chess_arr.length; i++) {
            let random_index = this.RandomColor()
            let temp = random_chess_arr[random_index]
            random_chess_arr[random_index] = random_chess_arr[i]
            random_chess_arr[i] = temp
            if (i == 1) {

            }

            return random_chess_arr
        }
    }

    public RandomChess() {

        return this.GenRandomChessArr()[0]
    }

    public GenRandomChess() {

        let chess_type = this.RandomChess()
        let chess = new ElimChess(chess_type)
        let value = this.GetScoreVlaue(chess_type)
        if (value) {
            let buff = new ElimChessBuff(this.ChessBuffType.Score)
            buff.SetParam(value)
            chess.SetBuff(buff)
        }
        return chess
    }

    public GenBaseMap(x_len?, y_len?) {

        this.elim_map = []
        this.x_len = x_len
        this.y_len = y_len
        for (let i = 0; i < x_len; i++) {
            this.elim_map[i] = []
            for (let j = 0; j < y_len; j++) {
                this.elim_map[i][j] = -1
            }
        }
    }

    public PrintMap(elim_map?, bool?) {

        if (!elim_map) {
            return
        }

        if (!bool) return

        // for (let i = elim_map.length - 1; i >= 0; i -= 1) {
        //     let x_value = ""
        //     for (let j = 0; j < elim_map[i].length; j++) {
        //         x_value = x_value + elim_map[i][j] + ','
        //     }
        // }

    }

    public SetElimMapChess(elim_map?, i?, j?, chess_type?) {

        elim_map[i][j] = chess_type
        let value = this.GetScoreVlaue(chess_type)
        if (value) {
            table.insert(this.init_buff_list, [
                i,
                j,
                this.ChessBuffType.Score,
                value,
            ])
        }
    }

    public GenFullValue() {

        this.init_buff_list = []
        let x_len = this.x_len
        let y_len = this.y_len
        let elim_map = this.elim_map
        let can_elim = 0
        for (let i = 0; i < x_len; i++) {
            for (let j = 0; j < y_len; j++) {
                let random_arr = this.GenRandomChessArr()
                for (let k = 0; k < random_arr.length; k++) {
                    let num = 0
                    if (i < 2 && j < 2) {
                        this.SetElimMapChess(elim_map, i, j, random_arr[k])
                        break
                    }
                    else if (i < 2 && j >= 2) {
                        if (elim_map[i][j - 1] != elim_map[i][j - 2]) {
                            this.SetElimMapChess(elim_map, i, j, random_arr[k])
                            break
                        } else {
                            if (random_arr[k] != elim_map[i][j - 1]) {
                                this.SetElimMapChess(elim_map, i, j, random_arr[k])
                                break
                            }
                        }
                    }
                    else if (i >= 2 && j < 2) {
                        if (elim_map[i - 1][j] == elim_map[i - 2][j]) {
                            if (random_arr[k] != elim_map[i - 1][j]) {
                                this.SetElimMapChess(elim_map, i, j, random_arr[k])
                                break
                            }
                        } else {
                            this.SetElimMapChess(elim_map, i, j, random_arr[k])
                            break
                        }
                    }
                    else if (i >= 2 && j >= 2) {
                        if (elim_map[i - 1][j] == elim_map[i - 2][j]) {
                            if (random_arr[k] != elim_map[i - 1][j]) {
                                num = num + 1
                            }
                        } else {
                            num = num + 1
                        }
                        if ((elim_map[i][j - 1] == elim_map[i][j - 2])) {
                            if ((random_arr[k] != elim_map[i][j - 1])) {
                                num = num + 1
                            }
                        } else {
                            num = num + 1
                        }
                        if ((num == 2)) {
                            this.SetElimMapChess(elim_map, i, j, random_arr[k])
                            break
                        }
                    }
                }
            }
        }
    }

    /*
        检查可消除的组，穷举
    */
    public CheckElimGroup(limit_num?, tmp_elim_map?) {

        let find_num = 0
        let group_list = []
        let x_len = this.x_len
        let y_len = this.y_len
        let elim_map = (tmp_elim_map && Util.TableSize(tmp_elim_map) > 0) ? tmp_elim_map : this.elim_map
        for (let y = 0; y < y_len; y++) {
            for (let x = 0; x < x_len; x++) {
                let currentType = elim_map[x][y]
                if (x + 1 < x_len) {
                    if (elim_map[x][y] == elim_map[x][y]) {
                        if (x - 2 >= 0) {
                            if (elim_map[x - 2][y] == currentType) {
                                let group = [[x, y],
                                [x + 1, y],
                                [x - 2, y],
                                ]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                        if (x - 1 >= 0 && y - 1 >= 0) {
                            if (elim_map[x - 1][y - 1] == currentType) {
                                let group = [[x, y],
                                [x + 1, y],
                                [x - 1, y - 1],
                                ]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                        if (x + 2 < x_len && y - 1 >= 0) {
                            if (elim_map[x + 2][y - 1] == currentType) {
                                let group = [[x, y],
                                [x + 1, y],
                                [x + 2, y - 1]]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                        if (x + 3 < x_len) {
                            if (elim_map[x + 3][y] == currentType) {
                                let group = [[x, y],
                                [x + 1, y],
                                [x + 3, y]]

                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                        if (x + 2 < x_len && y + 1 < y_len) {
                            if (elim_map[x + 2][y] == currentType) {
                                let group = [[x, y],
                                [x + 1, y],
                                [x + 2, y + 1]]

                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                        if (x - 1 >= 0 && y + 1 < y_len) {
                            if (elim_map[x - 1][y] == currentType) {
                                let group = [[x, y],
                                [x + 1, y],
                                [x - 1, y + 1]]

                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                    }
                }
                if (x + 2 < x_len) {
                    if (elim_map[x][y] == elim_map[x + 2][y]) {
                        let current = elim_map[x][y]
                        if (y - 1 >= 0) {
                            if (elim_map[x][y - 1] == currentType) {
                                let group = [[x, y],
                                [x + 1, y - 1],
                                [x + 2, y],
                                ]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                        if (y + 1 < y_len) {
                            if (elim_map[x][y] == currentType) {
                                let group = [[x, y],
                                [x + 1, y + 1],
                                [x + 2, y],
                                ]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                        if (x + 3 < x_len) {
                            if (elim_map[x + 3][y] == currentType) {
                                let group = [[x, y],
                                [x + 2, y],
                                [x + 3, y],
                                ]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                    }

                }
                if (y + 1 < y_len) {
                    if (elim_map[x][y] == elim_map[x][y]) {
                        if (y - 2 >= 0) {
                            if (elim_map[x][y - 2] == currentType) {
                                let group = [[x, y],
                                [x, y + 1],
                                [x, y - 2],
                                ]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                        if (x + 1 < x_len && y - 1 >= 0) {
                            if (elim_map[x][y - 1] == currentType) {
                                let group = [[x, y],
                                [x, y + 1],
                                [x + 1, y - 1],
                                ]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                        if (x + 1 < x_len && y + 2 < y_len) {
                            if (elim_map[x][y + 2] == currentType) {
                                let group = [[x, y],
                                [x, y + 1],
                                [x + 1, y + 2],
                                ]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                        if (y + 3 < y_len) {
                            if (elim_map[x][y + 3] == currentType) {
                                let group = [[x, y],
                                [x, y + 1],
                                [x, y + 3],
                                ]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                        if (x - 1 >= 0 && y + 2 < y_len) {
                            if (elim_map[x - 1][y + 2] == currentType) {
                                let group = [[x, y],
                                [x, y + 1],
                                [x - 1, y + 2],
                                ]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                        if (x - 1 >= 0 && y - 1 >= 0) {
                            if (elim_map[x - 1][y - 1] == currentType) {
                                let group = [[x, y],
                                [x, y + 1],
                                [x - 1, y - 1],
                                ]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                    }
                }
                if (y + 2 < y_len) {
                    if (elim_map[x][y] == elim_map[x][y + 2]) {
                        if (x + 1 < x_len) {
                            if (elim_map[x][y] == currentType) {
                                let group = [[x, y],
                                [x, y + 2],
                                [x + 1, y + 1],
                                ]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                        if (x - 1 >= 0) {
                            if (elim_map[x - 1][y] == currentType) {
                                let group = [[x, y],
                                [x, y + 2],
                                [x - 1, y + 1],
                                ]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                        if (y + 3 < y_len) {
                            if (elim_map[x][y + 3] == currentType) {
                                let group = [[x, y],
                                [x, y + 2],
                                [x, y + 3],
                                ]
                                table.insert(group_list, group)
                                find_num = find_num + 1
                                if (find_num >= limit_num) {
                                    return [find_num, group_list]
                                }
                            }
                        }
                    }
                }
            }
        }
        return [find_num, group_list]
    }

    public CheckNewElimGroup(limit_num?) {

        let [tmp_elim_map] = this.ChessBoard2Map()
        return this.CheckElimGroup(limit_num, tmp_elim_map)
    }


    public RandomArray(array?, length?) {

        let index, value, median

        if (!array) {
            return
        }

        // 发牌的时候对于已经分配的数据不再修改
        for (let index = 0; index < array.length; index++) {
            value = Util.RandomRange(index, (length - index - 1))
            median = array[index]
            array[index] = array[value]
            array[value] = median
        }
    }

    /*
        生成棋盘
    */
    public GenChessBorad(x_len?, y_len?, limit_num?) {

        this.mini_game_model.SetResumeGame(false)
        this.x_len = x_len
        this.y_len = y_len
        this.limit_num = limit_num

        if (this.UseTestMap) {
            return this.TestMap()
        }

        // 恢复
        if (this.CheckResumeBoard()) {
            return this.ResumeBoard()
        }

        this.InitScoreBuff()
        this.GenNewMap()
        let find_num = 0
        while (find_num < limit_num) {
            this.GenFullValue()
            let a = this.CheckElimGroup(limit_num)
            find_num = Number(a[0])
        }

        //@huoyijian
        // //测试棋盘
        // this.elim_map = [
        //     [4, 5, 5, 1, 5, 2, 5, 5],
        //     [1, 5, 3, 2, 3, 2, 4, 2],
        //     [2, 4, 3, 3, 2, 3, 5, 3],
        //     [3, 1, 4, 1, 3, 4, 3, 2],
        //     [1, 5, 3, 5, 1, 4, 2, 3],
        //     [3, 4, 1, 3, 2, 3, 3, 2],
        //     [5, 2, 2, 4, 3, 2, 5, 1],
        //     [2, 2, 5, 1, 3, 4, 1, 2]
        // ]

        // //测试特效    [行, 列, buff类型, 倍数]
        // this.init_buff_list = [
        //     [0, 1, 1, 2],
        //     [0, 0, 2, 2],
        //     [4, 4, 3, 2],
        //     [5, 3, 3, 2],
        //     [6, 4, 4, 6]
        // ]
        this.PrintMap(this.elim_map)
        return [this.elim_map, this.init_buff_list]
    }

    public GenNewMap() {

        let x_len = this.x_len
        let y_len = this.y_len
        this.GenBaseMap(x_len, y_len)
        let find_num = 0
        while (find_num < this.limit_num) {
            this.GenFullValue()
            let a = this.CheckElimGroup(this.limit_num)
            find_num = Number(a[0])
        }
    }

    public ResetChessBoard() {

        let chess_board = ElimGameMgr.GetInstance().chess_board
        if (!chess_board) {
            return
        }

        this.GenNewMap()
        let x_len = this.x_len
        let y_len = this.y_len
        let elim_map = this.elim_map

        let blocks = chess_board.blocks
        for (let x = 0; x < x_len; x++) {
            for (let y = 0; y < y_len; y++) {
                let block = blocks[x][y]
                if (block) {
                    block.OnReset()
                    let chess = block.GetChess()
                    if (!chess) {
                        block.SetChess(new ElimChess(elim_map[x][y]))
                    } else {
                        chess.chess_type = elim_map[x][y]
                    }
                }
            }
        }
        this.InitBuff(blocks)
        return [elim_map, this.init_buff_list]
    }

    /*
        洗牌
    */
    public Shuffle() {

        let chess_board = ElimGameMgr.GetInstance().chess_board
        if (!chess_board) {
            return
        }
        // TODO
        //egret.log("////////////////>洗牌前")
        //this:ChessBoard2Map()

        // 
        let x_len = this.x_len
        let y_len = this.y_len

        let block_list = []
        let blocks = chess_board.blocks
        let block
        for (let i = 0; i < x_len; i++) {
            for (let j = 0; j < y_len; j++) {
                block = blocks[i][j]
                table.insert(block_list, block)
            }
        }
        let RandBlock = () => {
            let index = Util.RandomRange(0, block_list.length - 1)
            let tmp_block = block_list[index]
            table.remove(block_list, index)
            return tmp_block
        }
        let RandDiffBlock = (diff_chess_type1?, diff_chess_type2?) => {
            let tmp_block = RandBlock()
            let loop_num = 0
            if (diff_chess_type1 && diff_chess_type2) {
                while (((tmp_block.GetChessType() == diff_chess_type1 || tmp_block.GetChessType() == diff_chess_type2) && loop_num < 5)) {
                    table.insert(block_list, tmp_block)
                    tmp_block = RandBlock()
                    loop_num = loop_num + 1
                }
            }
            else if (diff_chess_type1) {
                while ((tmp_block.GetChessType() == diff_chess_type1 && loop_num < 5)) {
                    table.insert(block_list, tmp_block)
                    tmp_block = RandBlock()
                    loop_num = loop_num + 1
                }
            }
            else if (diff_chess_type2) {
                while ((tmp_block.GetChessType() == diff_chess_type2 && loop_num < 5)) {
                    table.insert(block_list, tmp_block)
                    tmp_block = RandBlock()
                    loop_num = loop_num + 1
                }
            }
            let is_new_chess = false
            let buff_type, buff_value
            if (loop_num >= 5) {
                // 极端情况重新指定棋子
                if (tmp_block.GetChessType() == diff_chess_type1 || tmp_block.GetChessType() == diff_chess_type2) {
                    let random_arr = this.GenRandomChessArr()
                    for (let i = 1; i <= 5; i++) {
                        if (random_arr[i] != diff_chess_type1 && random_arr[i] != diff_chess_type2) {
                            let chess = tmp_block.GetChess()
                            if (this.IsScoreBuff(tmp_block.GetChessType())) {
                                if (!this.IsScoreBuff(random_arr[i])) {
                                    buff_type = -1
                                }
                            } else {
                                if (this.IsScoreBuff(random_arr[i])) {
                                    let buff = new ElimChessBuff(this.ChessBuffType.Score)
                                    buff.SetParam(this.GetScoreVlaue(random_arr[i]))
                                    chess.SetBuff(buff)
                                    buff_type = this.ChessBuffType.Score
                                    buff_value = this.GetScoreVlaue(random_arr[i])
                                }
                            }
                            chess.SetChessType(random_arr[i])
                            is_new_chess = true
                            break
                        }
                    }
                }
            }
            return [tmp_block, is_new_chess, buff_type, buff_value]
        }

        let new_blocks = []
        let action_list = []
        let SetBlockData = (i?, j?, diff_chess_type1?, diff_chess_type2?) => {
            let tmp_new_block, tmp_is_new_chess, buff_type, buff_value = RandDiffBlock(diff_chess_type1, diff_chess_type2)
            let new_chess_type
            if (tmp_is_new_chess) {
                new_chess_type = tmp_new_block.GetChessType()
            }
            action_list[i][j] = [
                tmp_new_block.x,
                tmp_new_block.y,
                new_chess_type,
                buff_type,
                buff_value,
            ]
            tmp_new_block.SetPos(i, j)
            return tmp_new_block
        }
        let new_block
        let is_new_chess
        for (let i = 0; i < x_len; i++) {
            new_blocks[i] = []
            action_list[i] = []
            for (let j = 0; j < y_len; j++) {
                let num = 0
                if (i < 2 && j < 2) {
                    new_block = SetBlockData(i, j)
                }
                else if (i < 2 && j >= 2) {
                    if (!new_blocks[i][j - 1] ||
                        !new_blocks[i][j - 2] ||
                        new_blocks[i][j - 1].GetChessType() != new_blocks[i][j - 2].GetChessType()
                    ) {
                        new_block = SetBlockData(i, j)
                    } else {
                        if (new_blocks[i][j - 1]) {
                            new_block = SetBlockData(i, j, new_blocks[i][j - 1].GetChessType())
                        } else {
                            new_block = SetBlockData(i, j)
                        }
                    }
                }
                else if (i >= 2 && j < 2) {
                    if (new_blocks[i - 1][j] && new_blocks[i - 2][j] && new_blocks[i - 1][j].GetChessType() == new_blocks[i - 2][j].GetChessType()) {
                        new_block = SetBlockData(i, j, new_blocks[i - 1][j].GetChessType())
                    } else {
                        new_block = SetBlockData(i, j)
                    }
                }
                else if (i >= 2 && j >= 2) {
                    //if (new_blocks[i-1][j] && new_blocks[i-2][j] && new_blocks[i-1][j].GetChessType() == new_blocks[i-2][j].GetChessType() ) {
                    //    num = num + 1
                    //}else{
                    //    num = num + 1
                    //}
                    //if (new_blocks[i][j-1] && new_blocks[i][j-2] && new_blocks[i][j-1].GetChessType() == new_blocks[i][j-2].GetChessType() ) {
                    //    //if ((random_arr[k] != elim_map[i][j-1]) ) {
                    //        num = num + 1
                    //    //}
                    //}else{
                    //    num = num + 1
                    //}
                    //if ((num == 2) ) {
                    let chess_type1, chess_type2
                    chess_type1 = new_blocks[i - 1][j] && new_blocks[i - 1][j].GetChessType() || null
                    chess_type2 = new_blocks[i][j - 1] && new_blocks[i][j - 1].GetChessType() || null
                    new_block = SetBlockData(i, j, chess_type1, chess_type2)
                    //this:SetElimMapChess(elim_map, i, j, random_arr[k])
                    //}
                }
                new_blocks[i][j] = new_block
            }
        }

        chess_board.blocks = null
        chess_board.blocks = new_blocks

        // TODO
        //egret.log("////////////////>洗牌后")
        //this:ChessBoard2Map()

        return action_list
    }

    public ShuffleGenNewBoard() {

        let action_list = this.Shuffle()
        let [num, _] = this.CheckNewElimGroup(1)
        while (num < 1) {
            action_list = this.Shuffle()
            num = this.CheckNewElimGroup(1)[0]
        }
        return action_list
    }

    public Map2ChessBoard() {

        let x_len = this.x_len
        let y_len = this.y_len
        let elim_map = this.elim_map
        let block
        let blocks = []
        for (let x = 0; x < x_len; x++) {
            blocks[x] = []
            for (let y = 0; y < y_len; y++) {
                block = new ElimBlock(x, y)
                block.SetChess(new ElimChess(elim_map[x][y]))
                blocks[x][y] = block
            }
        }
        this.InitBuff(blocks)
        return blocks
    }

    public InitBuff(blocks?) {

        if (!this.init_buff_list || !(Util.TableSize(this.init_buff_list) > 0)) {
            return
        }
        for (let _ = 0; _ < this.init_buff_list.length; _++) {
            let value = this.init_buff_list[_]
            let block = blocks[value[0]][value[1]]
            let chess: ElimChess = block.GetChess()
            let buff: ElimChessBuff = new ElimChessBuff(value[2])
            if (value[3]) {
                buff.SetParam(value[3])
            }
            chess.SetBuff(buff)
        }
    }

    public CheckResumeBoard() {

        let game_data = this.mini_game_model.game_data
        if (!game_data) {
            return false
        }
        if (!game_data.board || !(Util.TableSize(game_data.board) > 0)) {
            return false
        }
        return true
    }

    public ResumeBoard() {

        let game_data = this.mini_game_model.game_data
        let board = game_data.board

        let x_len = board.length
        let y_len = board[1].row_notes.length

        this.elim_map = []
        this.x_len = x_len
        this.y_len = y_len

        table.sort(board, (a?, b?) => {
            if (a.row_id != b.row_id) {
                return a.row_id < b.row_id
            }
            return false
        })
        for (let i = 0; i < x_len; i++) {
            let data = board[i]
            this.elim_map[i] = []
            for (let j = 0; j < data.row_notes.length; j++) {
                this.elim_map[i][j] = data.row_notes[j].note_id
            }
        }

        if (game_data.effect && Util.TableSize(game_data.effect) > 0) {
            this.init_buff_list = []
            for (let _ = 0; _ < game_data.effect.length; _++) {
                var value = game_data.effect[_]
                table.insert(this.init_buff_list, [
                    value.x, value.y, value.eff_type, value.param,
                ])
            }
        }

        // 积分棋
        if (game_data.score_chess) {
            this.score_buff_map = []
            for (let _ = 0; _ < game_data.score_chess.length; _++) {
                var value = game_data.score_chess[_]
                this.score_buff_map[value.note_id] = value.rate
                ElimGameMgr.GetInstance().Fire(ElimDefine.ElimEvent.SET_BUFF_SHOW, value.rate, value.note_id)
            }
        }

        this.mini_game_model.SetResumeGame(true)
        return [this.elim_map, this.init_buff_list, game_data.score]
    }

    public ChessBoard2Map() {

        let x_len = this.x_len
        let y_len = this.y_len
        let block
        let chess_board = ElimGameMgr.GetInstance().chess_board
        if (!chess_board) {
            return
        }
        let blocks = chess_board.blocks
        let buff_list = []
        for (let x = 0; x < x_len; x++) {
            if (!this.tmp_elim_map[x]) {
                this.tmp_elim_map[x] = []
            }
            for (let y = 0; y < y_len; y++) {
                let chess: ElimChess = blocks[x][y].GetChess()
                if (!chess) {
                    continue
                }
                this.tmp_elim_map[x][y] = chess && chess.chess_type || -1
                if (chess.HasBuff()) {
                    table.insert(buff_list, [
                        x,
                        y,
                        chess.GetBuffType(),
                        chess.GetBuffValue(),
                    ])
                }
            }
        }
        this.PrintMap(this.tmp_elim_map)
        return [this.tmp_elim_map, buff_list]
    }

    public PrintMapIp() {
        this.PrintMap(this.tmp_elim_map, true)
    }

    public RandomColor() {

        let rate_map = this.GetRandomRateMap()
        let sum = 0
        for (let _ in rate_map) {
            var value = rate_map[_]
            sum = sum + value
        }
        let rand_value = Util.RandomRange(1, sum)
        for (let color in rate_map) {
            var value = rate_map[color]
            sum = sum - value
            if (sum < rand_value) {
                return color
            }
        }
        return 1
    }

    public GetRandomRateMap() {

        if (!this.chess_gen_rate_map) {
            this.chess_gen_rate_map = []
            let rate_str = this.mini_game_model.GetValue(11)||"[{1,100},{2,200},{3,100},{4,100},{5,100}]"
            let rate_arr = ErlangParser.GetInstance().Parse(rate_str)
            for (let _ = 0; _ < rate_arr.length; _++) {
                var value = rate_arr[_]
                this.chess_gen_rate_map[Number(value[0]) - 1] = Number(value[1])
            }
        }
        return this.chess_gen_rate_map
    }

    public InitScoreBuff() {

        let color_list = [
            this.ChessType.Color1,
            this.ChessType.Color2,
            this.ChessType.Color3,
            this.ChessType.Color4,
            this.ChessType.Color5
        ]
        this.score_buff_map = []
        let rate_str = this.mini_game_model.GetValue(13)||"[{2,3}]"
        let score_rate_arr = ErlangParser.GetInstance().Parse(rate_str)
        if (score_rate_arr) {
            score_rate_arr = score_rate_arr[0]
            for (let key in score_rate_arr) {
                let rate_arr = score_rate_arr[key]
                let index = Util.RandomRange(0, color_list.length - 1)
                this.score_buff_map[color_list[index]] = Number(rate_arr)
                ElimGameMgr.GetInstance().Fire(ElimDefine.ElimEvent.SET_BUFF_SHOW, rate_arr, color_list[index])
                table.remove(color_list, index)
            }
        }
    }

    public IsScoreBuff(color?) {

        return this.score_buff_map[color] != null
    }

    public GetScoreVlaue(color?) {

        return this.score_buff_map[color]
    }

    public OnInitBoard() {

        let action_op = []
        let score_chess = []
        if (this.score_buff_map) {
            for (let color in this.score_buff_map) {
                var rate = this.score_buff_map[color]
                table.insert(score_chess, [color, rate])
            }
        }
        this.SyncBoardData(0, action_op, score_chess)
    }

    public OnAfterAction() {

        let chess_board = ElimGameMgr.GetInstance().chess_board
        let input_cmd = chess_board.input_cmd
        let action_op = []
        if (input_cmd) {
            action_op = [
                input_cmd.source_pos[0],
                input_cmd.source_pos[1],
                input_cmd.dir[0],
                input_cmd.dir[1],
                chess_board.calc.total_score,
            ]
        }
        this.SyncBoardData(1, action_op)
    }

    public OnAfterBonusTime() {

        this.OnAfterAction()
        this.mini_game_model.Fire(MiniGameModel.REQUEST_CCMD_EVENT, 39923)
    }

    public SyncBoardData(type?, action_op?, score_chess?) {

        let [elim_map, buff_list] = this.ChessBoard2Map()
        if (!elim_map) {
            return
        }
        score_chess = score_chess || {}
        this.mini_game_model.Fire(MiniGameModel.REQUEST_PROTO_LIST_39921,
            type,
            action_op,
            elim_map,
            buff_list,
            score_chess
        )
        this.SaveBoardData(elim_map, buff_list, score_chess)
    }


    public SetCheccBuff(x, y, eff_type, chess_type) {

        //[value.x, value.y, value.eff_type, value.param]
        let chess_board = ElimGameMgr.GetInstance().chess_board
        let blocks = chess_board.blocks
        let block: ElimBlock = blocks[x][y]
        let chess: ElimChess = block.GetChess()
        let buff = new ElimChessBuff(eff_type)
        // if (value[3]) {
        //     buff.SetParam(value[3])
        // }
        chess.SetBuff(buff)
        chess.SetChessType(chess_type)
    }

    public TestMap() {

        this.elim_map = [
            //case 1
            [5, 3, 1, 5, 3, 5, 3, 4],
            [1, 4, 4, 3, 3, 2, 4, 3],
            [3, 4, 5, 1, 4, 1, 2, 1],
            [1, 3, 2, 5, 2, 5, 4, 3],
            [3, 5, 4, 3, 4, 2, 1, 2],
            [2, 4, 2, 3, 1, 5, 1, 2],
            [2, 4, 2, 3, 2, 5, 3, 1],
            [2, 4, 2, 3, 1, 5, 1, 2],
        ]
        // this.PrintMap(this.elim_map)
        return this.elim_map
    }

    public SaveBoardData(board?, effect?, score_chess?) {

        let chess_board = ElimGameMgr.GetInstance().chess_board
        if (!chess_board) {
            return
        }
        let data = { board: [], score: null, effect: [], score_chess: [] }
        data.board = []
        data.score = chess_board.calc.total_score
        // 棋盘
        for (let i = 0; i < board.length; i++) {
            var row = board[i]
            data.board[i] = []
            data.board[i].row_id = i
            data.board[i].row_notes = []
            for (let j = 0; j < row.length; j++) {
                var col = row[j]
                data.board[i].row_notes[j] = []
                data.board[i].row_notes[j].note_id = board[i][j]
            }
        }

        data.effect = []
        // 效果
        for (let i = 0; i < effect.length; i++) {
            var info = effect[i]
            data.effect[i] = []
            data.effect[i].x = info[0]
            data.effect[i].y = info[1]
            data.effect[i].eff_type = info[2]
            data.effect[i].param = info[3]
        }

        // 积分
        if (score_chess && Util.TableSize(score_chess) > 0) {
            data.score_chess = []
            for (let i = 0; i < score_chess.length; i++) {
                var info = score_chess[i]
                data.score_chess[i] = []
                data.score_chess[i].note_id = info[0]
                data.score_chess[i].rate = info[1]
            }
        }

        this.mini_game_model.SetBoardData(data)
    }
}