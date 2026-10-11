import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

export class DungeonPartnerStarView extends BaseView1 {


    model: DungeonPartnerModel
    need_refresh_data
    page
    stage_data
    total_score
    pos:Laya.Point
    public constructor() {
        super()
        this.base_file = "dungeonPartner"
        this.layout_file = "DungeonPartnerStarView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background2 = true
        this.click_bg_toClose = true
        this.background_alpha = 0

        this.model = DungeonPartnerModel.GetInstance()

        this.load_callback = () => {
            this.LoadSuccess()
        }
        this.open_callback = () =>{
            this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61106, this.page)
            this.display_obj.x = this.pos.x
            this.display_obj.y = this.pos.y - this.display_obj.height / 2
            this.pos.recover()
        }

        this.destroy_callback = () => {
            this.Remove()
        }
    }

    public LoadSuccess() {
        this.InitEvent()
        
        this._img_progress.width = this.total_score / 27 * 420
    }

    public InitEvent() {
        let onClickBtnHandler = (e:Laya.Event)=> {
            if(e.target == this._img_reward1){
                this.ClickStageTreasureBox(0)
            }else if(e.target == this._img_reward2){
                this.ClickStageTreasureBox(1)
            }else if(e.target == this._img_reward3){
                this.ClickStageTreasureBox(2)
            }
        }
        Util.AddClickEvent(this._img_reward1, onClickBtnHandler, this, true)
		Util.AddClickEvent(this._img_reward2, onClickBtnHandler, this, true)
		Util.AddClickEvent(this._img_reward3, onClickBtnHandler, this, true)

        this.BindEvent(this.model, DungeonPartnerModel.UPDATE_PARTNER_VIEW_STAGE_REWARD, (scmd61106?) => {
			this.UpdateStageReward(scmd61106)
		})
    }

    public UpdateStageReward(stage_data?) {

		// PrintTable(stage_data)
		//test
		// stage_data = [level = 1, stage_reward = [[score : 9, status : 0], [score : 18, status : 0], [score : 27, status : 0]] ]
		this.stage_data = stage_data
		for (let i = 0; i < stage_data.stage_reward.length; i++) {
			let v = stage_data.stage_reward[i]
			this[`_img_reward_get${i + 1}`].visible = 2 == v.status  //已领取
			this[`_img_reward_red${i + 1}`].visible = 1 == v.status  //可领取
		}
	}

	public ClickStageTreasureBox(index?) {
		if (!this.stage_data) {
			return
		}
		let info = this.stage_data.stage_reward[index]
		if (1 == info.status) { //可领取
			this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61108, this.model.GetPage(), info.score)
		} else {
			//显示阶段奖励
			let data = { level: this.model.GetPage(), stage_info: info }
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonPartnerStageRewardView", data)
		}
	}

    public Open(...parms) {
        this.page = parms[0]
        this.total_score = parms[1]
        this.pos = parms[2]
        super.Open()
    }

    public UpdateView() {

    }

    public Remove() {

    }


    _img_bg: Laya.Image
    _img_bg2: Laya.Image
    _img_progress: Laya.Image
    _img_reward1: Laya.Image
    _img_reward_bg1: Laya.Image
    _img_reward_star1: Laya.Image
    _lb_reward1: Laya.Label
    _img_reward_get1: Laya.Image
    _img_reward_red1: Laya.Image
    _img_reward2: Laya.Image
    _img_reward_bg2: Laya.Image
    _img_reward_star2: Laya.Image
    _lb_reward2: Laya.Label
    _img_reward_get2: Laya.Image
    _img_reward_red2: Laya.Image
    _img_reward3: Laya.Image
    _img_reward_bg3: Laya.Image
    _img_reward_star3: Laya.Image
    _lb_reward3: Laya.Label
    _img_reward_get3: Laya.Image
    _img_reward_red3: Laya.Image
    public GetComponents() {
        [
            this._img_bg,
            this._img_bg2,
            this._img_progress,
            this._img_reward1,
            this._img_reward_bg1,
            this._img_reward_star1,
            this._lb_reward1,
            this._img_reward_get1,
            this._img_reward_red1,
            this._img_reward2,
            this._img_reward_bg2,
            this._img_reward_star2,
            this._lb_reward2,
            this._img_reward_get2,
            this._img_reward_red2,
            this._img_reward3,
            this._img_reward_bg3,
            this._img_reward_star3,
            this._lb_reward3,
            this._img_reward_get3,
            this._img_reward_red3,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_bg2",
                "_img_progress",
                "_img_reward1",
                "_img_reward_bg1",
                "_img_reward_star1",
                "_lb_reward1",
                "_img_reward_get1",
                "_img_reward_red1",
                "_img_reward2",
                "_img_reward_bg2",
                "_img_reward_star2",
                "_lb_reward2",
                "_img_reward_get2",
                "_img_reward_red2",
                "_img_reward3",
                "_img_reward_bg3",
                "_img_reward_star3",
                "_lb_reward3",
                "_img_reward_get3",
                "_img_reward_red3",
            ])
    }
}
window["DungeonPartnerStarView"] = DungeonPartnerStarView