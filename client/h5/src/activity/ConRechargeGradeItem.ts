import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
export class ConRechargeGradeItem extends BaseItem1 {
    _img_bg: Laya.Image
    _Image111: Laya.Image
    _img_over: Laya.Image
    _btn_recharge: Laya.Box
    _Image11: Laya.Image
    labelDisplay: Laya.Label
    _btn_get: Laya.Box
    _Image1: Laya.Image
    _reddot: Laya.Image
    labelDisplay1: Laya.Label
    _Scroller1: Laya.Panel
    _gp_reward: Laya.HBox
    _lb_title: Laya.HTMLDivElement
    _lb_progress: Laya.HTMLDivElement
    effect: Laya.Box
    done: Laya.Image
    needRefresh
    data
    _model = CustomActivityModel.GetInstance()
    _enough = false
    _canGet = false
    _item_list = []
    public constructor(parent) {
        super(parent)
        this.base_file = "activity"
        this.layout_file = "ConRechargeGradeItem"
        this.load_callback = () => {

            this.LoadSuccess()

        }

    }
    public DeleteMe() {
        this.ClearUIEffect(this.effect)
        for (let _tmpi in this._item_list) {
            var item = this._item_list[_tmpi]
            item.DeleteMe()
        }
        this._item_list = []
        super.DeleteMe()
    }

    public LoadSuccess() {

        this._Scroller1.hScrollBar.visible = false
        if (this.needRefresh) {
            this.InitView()
        }
        this.InitEvent()
    }



    public InitEvent() {
        Util.AddClickEvent(this._btn_get, () => {
            let data = this.data
            if (this._canGet || (this._enough && data.status == 0)) {
                this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, data.base_type, data.sub_type, data.grade)
            }
            CustomActivityModel.GetInstance().SetActRedDot()
        }, this, true)

        Util.AddClickEvent(this._btn_recharge, () => {
            OpenFun.OpenFunHandler(21)
        }, this, true)
        this.BindEvent(this._model, CustomActivityDefine.EVENT.UPDATE_RECHARGE_ITEM, () => {
            this.UpdateRecharge()
        })
    }



    public InitView() {
        if (!this.data) { return }
        this.AddUIEffect("ui_anniu_8", this.effect, undefined, { x: 15.7, y: 12, z: 14 }, true)
        this.UpdateRecharge()
        ResManager.GetInstance().SetImageSprite(this, this._Image111, "activity", "cjgh_004", true)
        ResManager.GetInstance().SetImageSprite(this, this._Image11, "common", "com_rect_btn1")
        ResManager.GetInstance().SetImageSprite(this, this._Image1, "common", "com_rect_btn3")
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconOtherPath("activity", "grade_bg"))
        //ResManager.GetInstance().SetImageSprite(this, this._img_over, "activity", "ui_cbdb_05", true)
        // this._img_over.x = 500
        // this._img_over.width = 123
        // this._img_over.height = 56
        this.labelDisplay.stroke = 2
        this.labelDisplay.strokeColor = "#c95b37"
        this.labelDisplay1.stroke = 2
        this.labelDisplay1.strokeColor = "#c5373d"
    }
    public UpdateRecharge() {

        let data = this.data
        let cond = CustomActivityModel.GetInstance().GetActCondition(data.base_type, data.sub_type, "data", data.grade)
        let act_data = this._model.GetActData(this.data.base_type, this.data.sub_type)
        if (!act_data) return
        let is_today = cond.tier && Number(cond.tier) == 1
        let total = 0
        let recharge_list = this._model.GetActRechargeOneDay()
        let recharge_list1 = []
        let finish_count = 0
        if (recharge_list && Util.TableSize(recharge_list) > 0) {
            for (let i = 0; i <= Util.TableSize(recharge_list) - 1; i++) {
                if (recharge_list[i].total_gold > 0) {
                    table.insert(recharge_list1, recharge_list[i].total_gold)
                    if (recharge_list[i].total_gold >= Number(cond.gold)) {
                        finish_count++
                    }
                }
            }
        }
        if (this._model.GetActRechargeDay() < Number(cond.gold)) {
            finish_count++
        }
        total = total == null && 0 || total
        let target = is_today && Number(cond.today_gold) || Number(cond.gold)
        target = target == null && 0 || target
        let enough = total >= target
        let canGet = data.status == 1

        let day_ref = "<font color='#ffe82a'>" + cond.day + "</font>"
        this._lb_title.style.bold = true
        this._lb_title.innerHTML = "累计" + day_ref + "天" + "<font color ='#ffe82a'>" + "充值" + target / 10 + "元</font>,可领取奖励！"
        this._reddot.visible = data.status == 1
        this._btn_get.visible = data.status == 1


        let condition = CustomActivityModel.GetInstance().GetActCondition(this.data.base_type, this.data.sub_type, "data", this.data.grade)
        let list = act_data.reward_list
        let count = 0
        for (let i = 0; i < list.length; i++) {
            let v = list[i]
            let condi = CustomActivityModel.GetInstance().GetActCondition(this.data.base_type, this.data.sub_type, "data", v.grade)
            if (condi.tier == this.data.now_select_tier && condi.grade == 1) {
                if (v.status == 1 || v.status == 2) {
                    count++
                }
            }
            else if ((condi.tier == this.data.now_select_tier) || !condi.tier) {
                if (v.status == 1 || v.status == 2) {
                    count++
                }
            }
        }
        let today_recharge = CustomActivityModel.GetInstance().GetActRechargeDay() / 10
        let today_num = Number(target / 10)

        this._btn_recharge.visible = data.status == 0 && today_recharge < today_num
        this._img_over.visible = data.status == 0 && today_recharge >= today_num
        this.done.visible = data.status == 2
        let day = condition && condition.day ? condition.day : list.length
        if (condition) {
            this._lb_progress.innerHTML = "已达成天数:" + "<font color = '#d15e00'>" + count + "</font>/" + condition.day
        } else {
            this._lb_progress.innerHTML = "已达成天数:" + "<font color = '#d15e00'>" + count + "</font>/" + list.length
        }
        let total_day = condition ? condition.day : list.length
        let is_tommor = Number(total_day) - Number(count) == 1 ? true : false
        let source = is_tommor ? "mingtian_ling" : "today"
        ResManager.GetInstance().SetImageSprite(this, this._img_over, "activity", source, true)
        let parent = <Laya.HBox>this._lb_progress.parent
        if (parent) parent.refresh()
        this._lb_progress.visible = Number(day) != count
        // if (finish_count == cond.day) {
        //     this._lb_progress.text = "（已充值:<font color = '#0a953e'>" + this._model.GetActRechargeDay() / 10 + "元</font>）"
        //     this._lb_progress.visible = data.status == 2 ? false : true
        // } else {
        //     this._lb_progress.visible = false
        // }
        this._enough = enough
        this._canGet = canGet
        let rewards = this._model.GetActReward(data.base_type, data.sub_type, data.form_type, data.reward)
        this.UpdateItems(rewards)
    }

    public UpdateItems(list?) {

        for (let i = 0; i < list.length; i++) {
            let info = list[i]
            let item = this._item_list[i]
            if (!item) {
                item = new EquipmentItem(this._gp_reward)
                item.SetItemSize(87, 87)
                item.Load()
                this._item_list[i] = item
            }
            let [type_id, _] = GoodsModel.GetInstance().GetMappingTypeId(info[0], info[1])
            item.SetData(type_id, info[2])
            item.SetVisible(true)
        }

        for (let i = list.length; i < this._item_list.length; i++) {
            this._item_list[i].SetVisible(false)
        }
    }



    public SetData(data?) {
        this.data = data
        if (this.is_loaded) {
            this.InitView()
        }
        else {
            this.needRefresh = true
        }

    }






    public GetComponents() {
        [
            this._img_bg,
            this._Image111,
            this._img_over,
            this._btn_recharge,
            this._Image11,
            this.labelDisplay,
            this._btn_get,
            this._Image1,
            this._reddot,
            this.labelDisplay1,
            this._Scroller1,
            this._gp_reward,
            this._lb_title,
            this._lb_progress,
            this.effect,
            this.done
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_Image111",
                "_img_over",
                "_btn_recharge",
                "_Image11",
                "labelDisplay",
                "_btn_get",
                "_Image1",
                "_reddot",
                "labelDisplay1",
                "_Scroller1",
                "_gp_reward",
                "_lb_title",
                "_lb_progress",
                "effect",
                "done"
            ])
        this._lb_title.style.valign = "center"
        this._lb_title.style.color = "#ffffff"
        this._lb_title.style.wordWrap = false
        this._lb_title.style.fontSize = 20
        this._lb_progress.style.color = "#663915"
        this._lb_progress.style.fontSize = 18
        this._lb_progress.style.wordWrap = false
        this._lb_progress.style.bold = true
    }
}
window["ConRechargeGradeItem"] = ConRechargeGradeItem