import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { CrossServerViewIndex } from "../commonController/BossController"
import { BossModel } from "../commonModel/BossModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import "../eudaemon/EudaemonEnterView"
import { EternityDefine, EternityModel } from "../commonModel/EternityModel"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { OpenMode } from "../common/BaseView1"
import { SentientActEvent, SentientActModel } from "../commonModel/SentientActModel"
import { GhostWalkEvent, GhostWalkModel } from "../commonModel/GhostWalkModel"
import { CommonManager } from "../common/CommonManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"

export class CrossServerEnterView extends BaseWindowComponent {
	boss_model: BossModel
	eternity_model
	seahege_model
	tsCrack_model
	public constructor() {
		super()

		this.eternity_model = EternityModel.GetInstance()
		//this.seahege_model = SeaHegemonyModel.GetInstance()
		this.tsCrack_model = TSCrackModel.GetInstance()
		this.boss_model = BossModel.GetInstance()
		this.open_mode = OpenMode.OpenOnly
		this.dependent_res = ["kfIcon","boss"]
		this.destroy_imm = true
		this.back_login_toClose = true
		this.titleStr = "common.ui_title_kf"

		this.tabStrList = [
			{ label: "蜃气楼" },
			{ label: "怨灵封印" },
			{ label: "秘境大妖" },
			{ label: "天启之源" },
			{ label: "时空圣痕" },
			{ label: "众生之门" },
			{ label: "百鬼夜行" },
		]

		this.viewClassList = [
			"EudaemonEnterView",
			"BossDomainView",
			"BossMysteryEnterView",
			"EternityMainView",
			"TSCrackMainView",
			"SentientActMainView",
			"GhostWalkView"
		]

		this.tab_new_cond = {
			2: () => {
				return CommonManager.GetInstance().CheckFuncOpenState("EudaemonEnterView", true)
				// return level >= holy_seal_model.open_lv
			}
		}

		this.bg_list = [
			"ui_kfa_001.jpg",
			"ui_kaf_zd011.jpg",
			"ui_chief_bg5.jpg",
			"ui_kaf_xz15.jpg",
			null,
			"ui_zong_bg.jpg",
			"ui_bai_bg.jpg"
		]

		this.instruction_list = [
			null,
			InstructionType.BossDomain,
			InstructionType.BossMystery,
			InstructionType.ETERNITY,
			null
		]

		this.window_load_back = () => {
			this.InitWindowEvent()
		}
	}

	public RefreshEnternityRed() {
		let bool = this.eternity_model.GetAllRedStatus()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CrossServerEnterView", CrossServerViewIndex.ENTERNITY, bool)
	}

	public RefreshTSCrackRed() {
		let bool = this.tsCrack_model.GetRedState()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CrossServerEnterView", CrossServerViewIndex.TSCrack, bool)
	}

	public RefreshEudaemonBossRed() {
		let bool = this.boss_model.GetEudaemonRed() || this.boss_model.GetEduBossRed()||this.boss_model.GetEduLoginRed()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CrossServerEnterView", CrossServerViewIndex.Eudaemon_Ridge_Boss, bool)
	}

	public RefreshDomianBossRed() {
		let bool = this.boss_model.GetDomainBossRed()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CrossServerEnterView", CrossServerViewIndex.Domain_Boss, bool)
	}



	public RefreshSentientActRed() {
		let bool = SentientActModel.GetInstance().GetActiveIconRed()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CrossServerEnterView", CrossServerViewIndex.SentientAct, bool)
	}
	public RefreshGhostWalkRed() {
		let bool = GhostWalkModel.ins.getRed()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CrossServerEnterView", CrossServerViewIndex.GhostWalk, bool)
	}

	private RefreshMystery(){
		GlobalEventSystem.Fire(
			EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
			"CrossServerEnterView",
			CrossServerViewIndex.Mystery_Boss,
			BossModel.GetInstance().GetMysteryBossRed()
		)
	}
	public InitWindowEvent() {

		this.RefreshEudaemonBossRed()
		this.RefreshSentientActRed()
		this.RefreshEnternityRed()
		this.RefreshDomianBossRed()
		this.RefreshGhostWalkRed()
		this.RefreshMystery()
		this.BindVar(this.eternity_model, "_act_data", () => {
			this.RefreshEnternityRed()
		}
		)

		this.BindEvent(this.boss_model, BossModel.UPDATE_EDU_BOSS_RED, () => {
			this.RefreshEudaemonBossRed()
		}

		)
		this.BindEvent(
			SentientActModel.GetInstance(),
			SentientActEvent.UPDATE_COUNT, (assist_num, enter_num) => {
				this.RefreshSentientActRed()
			}
		)
		this.BindEvent(GhostWalkModel.ins, GhostWalkEvent.RecvFmt20602, () => {
			this.RefreshGhostWalkRed()
		});

		// this.RefreshDomianBossRed()
		this.RefreshTSCrackRed()
		// this.BindEvent(this.boss_model, BossModel.BOSS_CHANGE_BG, (bg_name) => {
		// 	if (this.nowSelectIndex == CrossServerViewIndex.Domain_Boss) {
		// 		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetBigBgPath(bg_name + ".jpg"))
		// 	}
		// })
	}

	public Open(...new_args) {
		let parms = new_args;
		this.SetIndexParameter(new_args[0], new_args[1]);
		if (Object.values(CrossServerViewIndex).includes(parms[0])) {
			this.SetDefaultIndex(parms[0]);
		} else if (EternityDefine.MODULE_ID == parms[0]) {
			this.SetDefaultIndex(CrossServerViewIndex.ENTERNITY);
		}
		super.Open();
	}

}
window["CrossServerEnterView"] = CrossServerEnterView