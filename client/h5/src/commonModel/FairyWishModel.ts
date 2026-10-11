import { Config } from "../common/Config";
import { table } from "../common/table";
import { ServerTimeModel } from "../serverTime/ServerTimeModel";
import { EventDispatcher } from "../util/EventDispatcher";
import { RoleManager } from "./RoleManager";

export const FairyWishEvent = {
    OPEN_VIEW: "FairyWishEvent.OPEN_VIEW",
    REQUEST_PROTO: "FairyWishEvent.REQUEST_PROTO",
    REQUEST_UPDATE_PROTO: "FairyWishEvent.REQUEST_UPDATE_PROTO",
    UPDATE_NODE: "FairyWishEvent.UPDATE_NODE",
    SELECT_NODE: "FairyWishEvent.SELECT_NODE",
    ON_TOUCH_ICON: "FairyWishEvent.ON_TOUCH_ICON",
    UPDATE_ALL_POWER: "FairyWishEvent.UPDATE_ALL_POWER",
    UPDATE_FAIRY_BUY: "FairyWishEvent.UPDATE_FAIRY_BUY"
}

export class FairyWishModel extends EventDispatcher {
    static Instance: FairyWishModel
    fairy_info
    node_info
    red_info
    req_cache_=false
    public constructor() {
        super();

        if (FairyWishModel.Instance != null) {
            return
        }
        FairyWishModel.Instance = this
        this.fairy_info = {}
        this.node_info = {}
        this.red_info = {} //为1--一次都没有点击过图标，2--未购买 展示红点 3--未购买 一次性红点消失 
    }

    /**设置仙灵数据
     * 以仙灵id为key
     * 仙灵数据为value
    */
    public setFairyInfo(fairy_data?) {
        if (!fairy_data) return
        this.fairy_info[fairy_data.fairy_id] = fairy_data
        if (fairy_data.node_list) {
            this.node_info[fairy_data.fairy_id] = fairy_data.node_list
        }
        if (!this.red_info[fairy_data.fairy_id]) {
            this.red_info[fairy_data.fairy_id] = 2
        }
        this.Fire(FairyWishEvent.UPDATE_FAIRY_BUY)
    }

    /**更新仙灵节点信息 */
    public updateNodeInfo(node_data?) {
        if (!node_data || !this.node_info[node_data.fairy_id]) return
        for (let node of this.node_info[node_data.fairy_id]) {
            if (node.node_id == node_data.node_id && node_data.code == 1) {
                node.is_activate = 1
            }
        }
        this.Fire(FairyWishEvent.UPDATE_NODE, node_data.node_id)
    }

    public updateRedInfo(red_data?) {
        if (!red_data || !red_data.click_list) return
        for (let item of red_data.click_list) {
            if (this.red_info[item.fairy_id] == 3) continue
            if (item.times == 0) { //一次都没点击过
                this.red_info[item.fairy_id] = 2
            } else {
                this.red_info[item.fairy_id] = 2
            }
        }
    }
    /**仙灵数据 里面包含节点数据 但是更新的时候不更新里面的节点数据
     * 拿节点数据通过方法getNodeInfoById
     */
    public getFairyInfoById(fairy_id) {
        return this.fairy_info[fairy_id] || null
    }

    /**仙灵的某一节点数据 */
    public getNodeInfoByFairyId(fairy_id) {
        return this.node_info[fairy_id] || []
    }
    /**获取当前节点激活到哪一个 
     * 如果有红点则返回有红点的那个
    */
    public getFairyCurNodeLv(fairy_id) {
        if (!this.node_info[fairy_id]
             || this.checkNodeIsCanActive(fairy_id, 1)
             && !this.judgeNodeIsActive(fairy_id, 1)) return 1
        let cur_lv = 0
        let new_list = this.node_info[fairy_id].concat()
        table.sort(new_list,(a,b)=>{
            return a.node_id < b.node_id
        })
        for (let node of new_list) {
            if (node.is_activate == 0) {
                cur_lv = node.node_id
                break
            }else{
                cur_lv++
            }

        }
        // if (this.checkNodeIsCanActive(fairy_id, cur_lv + 1)) { //如果下一个节点可激活 则返回下一个节点
        //     cur_lv++
        // }
        return cur_lv
    }
    /**判断当前仙灵节点是否全部激活（是否满级） */
    public judgeFairyIsMax(fairy_id) {
        if (!this.node_info[fairy_id]) return false
        for (let node of this.node_info[fairy_id]) {
            if (!node.is_activate) return false
        }
        return true
    }
    /**判断当前仙灵节点是否激活**/
    public judgeNodeIsActive(fairy_id, node_id) {
        if (!this.node_info[fairy_id]) return false
        for (let node of this.node_info[fairy_id]) {
            if (node.node_id == node_id) {
                return node.is_activate == 1
            }
        }
        return false
    }

    public checkNodeIsCanActive(fairy_id, node_id) {
        if (!this.fairy_info[fairy_id] || !this.fairy_info[fairy_id].is_buy) return false
        let node_cfg = Config.PRELOAD_SERVER_CONFIG.config_fairy_node
        let node_info = node_cfg[`${fairy_id}@${node_id}`]
        let role = RoleManager.GetInstance().mainRoleInfo
        if (!node_info) return false
        let condition = JSON.parse(node_info.condition)
        for (let key in condition) {
            let c = condition[key]
            if (c[0] == "lv" && Number(role.level) >= Number(c[1])) {
                return true    //等级条件 后面根据策划与数值进行修改
            }
        }
        return false
    }
    /**传模块Id进行红点判断*/
    public ShowFairyRed(moudle) {
        let node_cfg = Config.PRELOAD_SERVER_CONFIG.config_fairy_node
        let fairy_cfg = Config.PRELOAD_SERVER_CONFIG.config_fairy
        let cur_info
        if (!fairy_cfg || !node_cfg) return false
        for (let item in fairy_cfg) {
            let fairy = fairy_cfg[item]
            if (fairy.module == moudle) {
                cur_info = fairy
                break
            }
        }
        if (!cur_info || !this.fairy_info[cur_info.id] || !this.fairy_info[cur_info.id].is_buy) return false
        let mainRoleVo = RoleManager.GetInstance().mainRoleInfo
        let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
        if(mainRoleVo.level < cur_info.open_lv || openDay < cur_info.open_day) return false
        for (let i = 1; ; i++) {
            let node_info = node_cfg[`${cur_info.id}@${i}`]
            if (!node_info) break
            if (this.judgeNodeIsActive(cur_info.id, node_info.fairy_lv)) continue //已激活的不做判断
            if (this.checkNodeIsCanActive(cur_info.id, node_info.fairy_lv)) return true
        }
        return false

    }

    public getNodeCombat(fairy_id, is_full) {
        if (!this.node_info || !this.node_info[fairy_id]) return 0
        let combat = 0
        if (is_full) {
            for (let item of this.node_info[fairy_id]) {
                if (item.is_activate == 0) continue
                combat += item.combat
            }
        } else {
            for (let item of this.node_info[fairy_id]) {
                combat += item.combat
            }
        }
        return combat
    }

    public setRedInfoById(fairy_id, status) { // 一次性红点消失
        this.red_info[fairy_id] = status
    }

    public onClickRedHide(fairy_id) {
        return this.red_info[fairy_id] || 2
    }
    public static GetInstance() {
        if (!FairyWishModel.Instance) {
            FairyWishModel.Instance = new FairyWishModel();
        }
        return FairyWishModel.Instance;
    }
}
window["FairyWishModel"] = FairyWishModel