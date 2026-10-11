import { BaseClass } from "../common/BaseClass"
import { table } from "../common/table"
import { ElimDefine } from "./ElimDefine"
import { ElimGameMgr } from "./ElimGameMgr"

export class ElimUtil {
    static AxisDirection = ElimDefine.AxisDirection
    static BlockDirection = ElimDefine.BlockDirection
    static ChessType = ElimDefine.ChessType

    public static TransformKey(x, y) {
        return (x + 1) * 10000 + y
    }

    /*
        块在同方向的检测
        TODO 待优化，同行或同列不再检测
    */
    public static CheckDirectionPosList(pos_list, axis_direction, limit_num) {
        if (!pos_list) {
            return [false, false]
        }
        if (limit_num < 1) {
            return [true, true]
        }

        let forward, reverse
        if (axis_direction == this.AxisDirection.X) {
            reverse = this.BlockDirection[2]
            forward = this.BlockDirection[3]
        }
        else if (axis_direction == this.AxisDirection.Y) {
            reverse = this.BlockDirection[1]
            forward = this.BlockDirection[0]
        }

        let quick_map = []
        let close_map = []
        let pos_check_ret = []
        let list = []
        let check_num = 0
        let tmp_x, tmp_y
        let tmp_rx, tmp_ry
        for (let _ = 0; _ < pos_list.length; _++) {
            var pos = pos_list[_]
            quick_map[this.TransformKey(pos[0], pos[1])] = true
        }
        for (let _ = 0; _ < pos_list.length; _++) {
            var pos = pos_list[_]
            check_num = 0
            list = []
            tmp_x = pos[0]
            tmp_y = pos[1]
            close_map = []
            while (quick_map[this.TransformKey(tmp_x, tmp_y)]) {
                if (!close_map[this.TransformKey(tmp_x, tmp_y)]) {
                    check_num = check_num + 1
                    table.insert(list, [tmp_x, tmp_y])
                    close_map[this.TransformKey(tmp_x, tmp_y)] = true
                }

                tmp_x = tmp_x + forward[0]
                tmp_y = tmp_y + forward[1]
                //if (check_num >= limit_num ) {
                //    return true
                //}
            }

            tmp_rx = pos[0]
            tmp_ry = pos[1]
            while (quick_map[this.TransformKey(tmp_rx, tmp_ry)]) {
                if (!close_map[this.TransformKey(tmp_rx, tmp_ry)]) {
                    check_num = check_num + 1
                    table.insert(list, [tmp_rx, tmp_ry])
                    close_map[this.TransformKey(tmp_rx, tmp_ry)] = true
                }

                tmp_rx = tmp_rx + reverse[0]
                tmp_ry = tmp_ry + reverse[1]
                //if (check_num >= limit_num ) {
                //    return true
                //}
            }

            pos_check_ret[this.TransformKey(pos[0], pos[1])] = {
                list: list,
                check_num: check_num,
            }
        }

        let check_ret
        let max_num = 0
        for (let _ in pos_check_ret) {
            var value = pos_check_ret[_]
            if (value.check_num > max_num) {
                max_num = value.check_num
                check_ret = value
            }
        }
        return [check_ret.check_num >= limit_num, check_ret.list]
    }

    /*
    public static CheckDirectionPosList(pos_list, axis_direction) {
        if (! pos_list ) {
            return null
        }
    
        let forward, reverse
        if (axis_direction == this.AxisDirection.X ) {
            reverse = this.BlockDirection[1]
            forward = this.BlockDirection[2]
        }
        else if (axis_direction == this.AxisDirection.Y ) {
            reverse = this.BlockDirection[4]
            forward = this.BlockDirection[3]
        }
    
        let quick_map = []
        let close_map = []
        let list = []
        let check_num = 0
        let tmp_x, tmp_y
        let tmp_rx, tmp_ry
        for (let _ = 0; _ < pos_list.length; _++) {
        var pos = pos_list[_]
            quick_map[this.TransformKey(pos.x, pos.y)] = true
        }
        for (let _ = 0; _ < pos_list.length; _++) {
        var pos = pos_list[_]
            check_num = 1
            tmp_x = pos.x + forward[1]
            tmp_y = pos.y + forward[2]
            while (quick_map[this.TransformKey(tmp_x, tmp_y)] ) {
                tmp_x = tmp_x + forward[1]
                tmp_y = tmp_y + forward[2]
                table.insert(list, {x=tmp_x, y=tmp_y})
            }
    
            tmp_rx = pos.x + reverse[1]
            tmp_ry = pos.y + reverse[2]
            while (quick_map[this.TransformKey(tmp_rx, tmp_ry)] ) {
                tmp_rx = tmp_rx + forward[1]
                tmp_ry = tmp_ry + forward[2]
                table.insert(list, {x=tmp_x, y=tmp_y})
            }
        }
        return list
    }
    *///

    public static IsSpecialChess(chess_type) {
        return chess_type >= this.ChessType.Special1
    }

    /*
        合并带去重
    */
    public static MergeList(list1, list2) {
        if (!list1 || !list2) {
            return
        }
        let list = []
        let quick_map = []
        let pos
        for (let i = 0; i < list1.length; i++) {
            pos = list1[i]
            let key = this.TransformKey(pos[0], pos[1])
            if (!quick_map[key]) {
                table.insert(list, pos)
                quick_map[key] = true
            }
        }
        for (let i = 0; i < list2.length; i++) {
            pos = list2[i]
            let key = this.TransformKey(pos[0], pos[1])
            if (!quick_map[key]) {
                table.insert(list, pos)
                quick_map[key] = true
            }
        }
        return list
    }

    /**生成彩蛋  寻找生成中心点 */
    public static FindCenterPos(list, axis) {
        table.sort(list, (a?, b?) => {
            let cav = axis == this.AxisDirection.X && a[1] || a[0]
            let cbv = axis == this.AxisDirection.X && b[1] || b[0]
            if (cav != cbv) {
                return cav < cbv
            }
            return false
        })
        let center_index = Math.floor(list.length / 2 + list.length % 2)
        let center_pos = list[center_index - 1]
        return center_pos
    }

    public static FindCircleIntersectPos(list) {
        let [_, xlist] = ElimUtil.CheckDirectionPosList(list, this.AxisDirection.X, 3)
        let [_1, ylist] = ElimUtil.CheckDirectionPosList(list, this.AxisDirection.Y, 3)

        let quick_map = []
        let intersect_pos
        for (let i = 0; i < xlist.length; i++) {
            quick_map[this.TransformKey(xlist[i][0], xlist[i][1])] = true
        }
        if (ylist) {
            for (let i = 0; i < ylist.length; i++) {
                if (quick_map[this.TransformKey(ylist[i][0], ylist[i][1])]) {
                    intersect_pos = ylist[i]
                    break
                }
            }
        }
        return intersect_pos
    }

    public static FindYFourPos(list) {
        let min_y = 999
        let min_pos
        for (let i = 0; i < list.length; i++) {
            if (list[i][1] < min_y) {
                min_y = list[i][1]
                min_pos = list[i]
            }
        }
        return min_pos
    }

    public static GetAnchoredPos(x, y) {
        let context = ElimGameMgr.GetInstance().context
        return [(context.block_width + 2) * y, (context.block_height + 2) * x]
    }

    /*
        逻辑坐标转换成棋子本地坐标
    */
    public static TransformTargetPos(local_logic_x, local_logic_y, target_logic_x, target_logic_y) {
        let [target_pos_x, target_pos_y] = ElimUtil.GetAnchoredPos(target_logic_x, target_logic_y)
        let [local_pos_x, local_pos_y] = ElimUtil.GetAnchoredPos(local_logic_x, local_logic_y)
        let new_pos_x = target_pos_x - local_pos_x
        let new_pos_y = target_pos_y - local_pos_y
        return [new_pos_x, new_pos_y]
    }
}