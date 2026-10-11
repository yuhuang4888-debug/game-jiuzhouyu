import { AutoFightManager } from "../autofight/AutoFightManager"
import { achvModel } from "../commonModel/achvModel"
import { BagModel } from "../commonModel/BagModel"
import { EquipModel, EquipEvent, EquipmentViewSecond_Menu_Type } from "../commonModel/EquipModel"
import { LungEvent, LungModel, SecretTreasureMainViewIndex } from "../commonModel/LungModel"
// import { SecretTreasureMainViewIndex } from "../rune/SecretTreasureMainView"
// import { SecretTreasureMainViewIndex } from "../commonModel/RuneModel"
// import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { BaseClass } from "./BaseClass"
import { BaseWindowComponent } from "./BaseWindowComponent"
import { CommonManager } from "./CommonManager"
import { EventName, SceneEventType } from "./EventName"
import { VipModel } from "../commonModel/VipModel"
import { OutWardBaseModel, enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { ShopIndex, ShopType } from "../commonModel/ShopModel"
import { BaseDungeonModel, DungeonEnterViewIndex } from "../commonModel/BaseDungeonModel"
import { GuildEvent, GuildModel } from "../commonModel/GuildModel"
import { HolyTerritoryModel, HTEvent } from "../commonModel/HolyTerritoryModel"
import { RuneTreasureModel, RuneTreasureEvent } from "../commonModel/RuneTreasureModel"
import { DemonDefine } from "../commonModel/DemonDefine"
import { investType, KaifuActivityModel, KaifuActivityModelEvent } from "../commonModel/KaifuActivityModel"
import { BaseEnterDefine } from "../baseEnterView/BaseEnterDefine"
import { MondaysAwardModel, MondaysAwardEvent } from "../commonModel/MondaysAwardModel"
import { BossModel } from "../commonModel/BossModel"
import { SuitActivityModel } from "../commonModel/SuitActivityModel"
import { BabyEvent, BabyModel } from "../commonModel/BabyModel"
import { DailyModel } from "../commonModel/DailyModel"
import { DailyEvent } from "../daily/DailyEvent"
import { GuildFightModel, GuildFightEvent } from "../commonModel/GuildFightModel"
import { CompositeEvent, CompositeModel } from "../commonModel/CompositeModel"
import { MarketEvent, MarketModel } from "../commonModel/MarketModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { GuildActEvent, GuildActivityModel } from "../commonModel/GuildActivityModel"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { SnatchTreasureModel } from "../commonModel/SnatchTreasureModel"
import { GameResPath } from "../util/GameResPath"
import { NoonPartyModel, NoonPEvent } from "../commonModel/NoonPartyModel"
import { TempleAwakenModel } from "../commonModel/TempleAwakenModel"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { StarEquipMainView } from "../starEquip/StarEquipMainView"
import { ViewManager } from "./ViewManager"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { Kf1vnEvent, Kf1vnModel } from "../commonModel/Kf1vnModel"
import { TopPkModel } from "../commonModel/TopPkModel"
import { SurpriseGiftModel } from "../commonModel/SurpriseGiftModel"
import { CrossServerViewIndex } from "../commonController/BossController"
import { FestivalModel, FestivalModelEvent } from "../commonModel/FestivalModel"
import { FestivalBaseView } from "../festival/FestivalBaseView"
import { EternityDefine } from "../commonModel/EternityModel"
import { LimitLevelShopModel } from "../commonModel/LimitLevelShopModel"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { PushGiftModel } from "../commonModel/PushGiftModel"
import { AdventureModel } from "../commonModel/AdventureModel"
import { FriendInviteModel } from "../commonModel/FriendInviteModel"
import { EnumGrowthForceViewType, GrowthForceModel, GrowthForceModelEvent } from "../commonModel/GrowthForceModel"
import { GrowthForceView } from "../growthForce/GrowthForceView"
import { TaskModel } from "../commonModel/TaskModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { AutoBrushBaseView, EnumAutoBrushTabType } from "../autoBrush/AutoBrushBaseView"
import { OnHookModel } from "../commonModel/OnHookModel"
import { EquipSuitBaseView } from "../suit/EquipSuitBaseView"
import { DsgtModel } from "../commonModel/DsgtModel"
import { DragonBallModel } from "../commonModel/DragonBallModel"

let local_GlobalEventSystem = GlobalEventSystem
let local_EventName = EventName
export class OpenFun extends BaseClass {

	public constructor() {
		super()

	}

	public static OpenFunHandler(jump_id, ...new_args) {
		let param = new_args
		if (!CommonManager.GetInstance().OpenFunCanJump(jump_id)) {
			return
		}

		//物品获取途径跳转到定制活动
		let list = jump_id.toString().split("_")
		if (list.length >= 2) {
			jump_id = 158
			param[0] = list[1]
			if (list[2] != undefined)
				param[1] = list[2]
		}
		jump_id = Number(jump_id)

		if (String(jump_id).substring(0, 3) == "612") {
			LimitLevelShopModel.GetInstance().Fire(LimitLevelShopModel.OPEN_VIEW, jump_id)
			return
		}

		let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
		switch (jump_id) {
			case 1:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_DUNGEON_MAIN_LINE_VIEW)
				break;
			case 2:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_MOUNT_PET_VIEW, 0)
				break;
			case 3:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, window["MainFunc"].Role, window["RoleViewIndex"].Wings)
				break;
			case 4:
			case 50:
				GuildModel.GetInstance().OpenGuildView(...new_args)
				break;
			case 5:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BossEnterView", BossModel.Index.Vip_Person_Boss)
				break;
			case 6:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Rune)
				break;
			case 7:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Exp)
				break;
			case 8:
			case 23:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIP_VIEW, 0, param[1])
				break;
			case 9:
				EquipModel.GetInstance().Fire(EquipEvent.OPEN_VIEW, "EquipView", 0)
				break;
			case 10:
				EquipModel.GetInstance().Fire(EquipEvent.OPEN_VIEW, "EquipView", 1)
				break;
			case 11:
				EquipModel.GetInstance().Fire(EquipEvent.OPEN_VIEW, "EquipView", 2)
				break;
			case 12:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_MEDAL_ENTER_VIEW, 0)
				break;
			case 13:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, window["MainFunc"].Role, window["RoleViewIndex"].Artifact)
				break;
			case 14:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, window["MainFunc"].Role, window["RoleViewIndex"].HolyDevice)
				break;
			case 15:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_MOUNT_PET_VIEW, 1)
				break;
			case 16:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_MOUNT_PET_VIEW, 2, param[0])
				break;
			case 17:
				let gmodel = GuildModel.GetInstance()
				if (GuildModel.IsHasGuild()) {
					gmodel.Fire(GuildEvent.OPEN_VIEW, "GuildDonateView")
				} else {
					gmodel.Fire(GuildEvent.OPEN_VIEW, "GuildJoinBaseView")
				}
				break;
			case 18:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_REINCARNATION_ENTER_VIEW)
				break;
			case 19:
			case 20:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIP_VIEW, 1)
				break;
			case 21:
				VipModel.GetInstance().Fire(VipModel.OPEN_VIEW, "RechargeView")
				break;
			case 22:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, window["MainFunc"].Role)
				break;
			case 24:
				// EquipModel.GetInstance().Fire(EquipEvent.OPEN_VIEW, "EquipSuitBaseView")
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, EquipSuitBaseView._layout_file);
				break;
			case 26:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BossEnterView", BossModel.Index.Field_Boss, param[0])
				break;
			case 27:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.Mystery_Boss, param[0])
				break;
			case 28:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BossEnterView", BossModel.Index.Abyss_Boss, param[0])
				break;
			case 29:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BossEnterView", BossModel.Index.Vip_Person_Boss, param[1])
				break;
			case 30:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BossEnterView", BossModel.Index.Suit_Boss, param[1])
				break;
			case 31:
				break;
			case 32:
				break;
			case 33:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BattleFieldEnterView", BaseEnterDefine.BattleFieldIndex().GuildFight)
				break;
			case 34:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_WELFARE_VIEW, 0)
				break;
			case 35:
				DsgtModel.GetInstance().Fire(DsgtModel.DSGT_OPEN_VIEW, "DsgtWindowView", param[0])
				break;
			case 36:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BossEnterView", BossModel.Index.Suit_Boss, param[0])
				break;
			case 37:
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_MOUNTPET_ILLUSION_VIEW, enum_OutWardType.Horse)
				break;
			case 38:
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_MOUNTPET_ILLUSION_VIEW, enum_OutWardType.Partner)
				break;
			case 39:
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_MOUNTPET_ILLUSION_VIEW, enum_OutWardType.Partner)
				break;
			case 40:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_MOUNT_PET_VIEW, 2)
				break;
			case 41:
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_OUTWARD_ILLUSION_VIEW, enum_OutWardType.Wings)
				break;
			case 42:
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_OUTWARD_ILLUSION_VIEW, enum_OutWardType.Artifact)
				break;
			case 43:
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_OUTWARD_ILLUSION_VIEW, enum_OutWardType.HolyDevice)
				break;
			case 44:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "SecretTreasureMainView", SecretTreasureMainViewIndex.MonBook)
				break;
			case 45:
				EquipModel.GetInstance().Fire(EquipEvent.OPEN_VIEW, "EquipView", 3)
				break;
			case 46:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, window["MainFunc"].Composite)
				break;
			case 47:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_BAG_VIEW, 3)
				break;
			case 48:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BattleFieldEnterView", BaseEnterDefine.BattleFieldIndex().Arena)
				break;
			case 49:
				local_GlobalEventSystem.Fire(
					local_EventName.OPEN_VIEW,
					"BattleFieldEnterView",
					BaseEnterDefine.BattleFieldIndex().NineSky
				)
				break;
			case 51:
				EquipModel.GetInstance().Fire(EquipEvent.OPEN_VIEW, "EquipView", 5)
				break;
			// case 52:
			// 	GuardModel.GetInstance().Fire(GuardModel.OPEN_VIEW)
			//break;
			case 53:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Material)
				break;
			case 621:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "WorldBattleEnterView", Kf1vnModel.MODULE_ID)
				break;
			case 55:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_PRAY_VIEW)
				break;
			case 56:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SMELTING_VIEW, 0)
				break;
			case 57:
				FriendInviteModel.GetInstance().Fire(FriendInviteModel.OPEN_FRIEND_INVITE_VIEW)
				break;
			case 58:
				if (GuildModel.IsHasGuild()) {
					let can_open = GuildModel.GetInstance().CanOpenGuildExplore()
					if (can_open) {
						GuildModel.GetInstance().Fire(GuildEvent.OPEN_VIEW, "GuildExploreBaseView")
					}
				} else {
					GuildModel.GetInstance().Fire(GuildEvent.OPEN_VIEW, "GuildJoinBaseView")
				}
				break;
			case 59:
				achvModel.GetInstance().Fire(achvModel.OP_V, "AchvEnterView")
				break;
			case 60:
				let index = param[0] || 0
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, index, param[1])
				break;
			case 61:
				KaifuActivityModel.GetInstance().KaifuActivityOpenFun(2, this.DiffCondOfChangeState())
				break;
			case 62:
				KaifuActivityModel.GetInstance().KaifuActivityOpenFun(1, this.DiffCondOfChangeState())
				break;
			case 63:
				KaifuActivityModel.GetInstance().KaifuActivityOpenFun(3, this.DiffCondOfChangeState())
				break;
			case 64:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "WorldBattleEnterView", DiamondFightModel.MODULE_ID)
				break;
			case 65:
				RuneTreasureModel.GetInstance().Fire(RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW, "RuneTreasureBaseView", 1)
				break;
			case 66:
			case 192:
				RuneTreasureModel.GetInstance().Fire(RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW, "RuneTreasureBaseView")
				break;
			case 67:
				// ShopPurchaseModel.GetInstance().Fire(ShopPurchaseModel.OPEN_VIEW, param)
				break;
			case 68:
				break;
			case 69:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_ROLE_SECOND_BUTTON, EquipmentViewSecond_Menu_Type.Skill, 1)
				break;
			case 70:
				// ViewPopLevelModel.GetInstance().SetViewPop('FirstRechargeView');
				FirstRechargeModel.GetInstance().Fire(FirstRechargeModel.OPEN_FIRST_RECHARGE_VIEW)
				break;
			case 71:
				RuneTreasureModel.GetInstance().Fire(RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW, "RuneTreasureBaseView")
				break;
			case 72:
				if (ServerTimeModel.GetInstance().GetOpenServerDay() == 1) {
					Message.show("活动开服第二天开启")
				}
				else
					local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@6@0", 3)
				break;
			case 73:
				local_GlobalEventSystem.Fire(
					local_EventName.OPEN_VIEW,
					"BattleFieldEnterView",
					BaseEnterDefine.BattleFieldIndex().DuelArena
				)
				break;
			case 76:
				TopPkModel.GetInstance().OpenTopView()
				break;
			case 75:
			case 77:
				let view = BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT
				if (view) {
					view.Close()
				}
				AutoFightManager.GetInstance().StartFieldSceneAutoFight()
				break;
			case 78:
				HolyTerritoryModel.GetInstance().Fire(HTEvent.OPEN_VIEW, "holyTerritoryMainView", 1, param[1])
				break;
			case 79:
				HolyTerritoryModel.GetInstance().Fire(HTEvent.OPEN_VIEW, "holyTerritoryMainView", 0)
				break;
			case 80:
				// EscortModel.GetInstance().Fire(EscortEvent.ESCORT_OPEN_VIEW, "EscortView")
				break;
			case 81:
				HolyTerritoryModel.GetInstance().Fire(HTEvent.OPEN_VIEW, "holyTerritoryMainView", 2)
				break;
			case 82:
				DailyModel.GetInstance().Fire(DailyEvent.DAILY_CLOSE_VIEW, "DailyView")
				DailyModel.GetInstance().Fire(DailyEvent.OPEN_VIEW, "DailyView")
				break;
			case 83:
				let openDay_83 = ServerTimeModel.GetInstance().GetOpenServerDay()
				let ter_max_open_day  = HolyTerritoryModel.GetInstance().OpenMaxDay()
				if(openDay_83>ter_max_open_day){
					//跨服异域
					let kf_open_data = KfHolyAreaModel.GetInstance().GetOpenState(true)
					if(kf_open_data[0]){
						local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.MedalShop, param[1])
					}else{
						Message.show(`${kf_open_data[1]}开启${OpenFun.OpenName(83)}`)
					}	
				}else{
					//本服异域
					if (HolyTerritoryModel.GetInstance().IsRealOpen(OpenFun.OpenName(83))) {
						HolyTerritoryModel.GetInstance().Fire(HTEvent.OPEN_VIEW, "holyTerritoryMainView", 3)
					}
				}

				break;
			case 84:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_BAG_VIEW, BagModel.Index.HolySeal)
				break;
			case 85:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageBaseView", 4)
				break;
			case 86:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.Eudaemon_Ridge_Boss)
				// Kf1vnModel.GetInstance().Fire(Kf1vnEvent.KF1VN_OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.Eudaemon_Ridge_Boss)
				break;
			case 87:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.Vie)
				break;
			case 88:
				HolyTerritoryModel.GetInstance().Fire(HTEvent.OPEN_VIEW, "holyTerritoryMainView", 1)
				break;
			case 89:
				DailyModel.GetInstance().Fire(DailyEvent.OPEN_VIEW, "DailyView", 1)
				break;
			case 90:
				CompositeModel.GetInstance().Fire(CompositeEvent.OPEN_RED_VIEW, 1)
				break;
			case 91:
				CompositeModel.GetInstance().Fire(CompositeEvent.OPEN_RED_VIEW, 2)
				break;
			case 92:
				RuneTreasureModel.GetInstance().Fire(RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW, "RuneTreasureBaseView", param)
				break;
			case 93:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageBaseView",param[0])
				break;
			case 94:
				MarketModel.GetInstance().Fire(MarketEvent.OPEN_VIEW, "MarketBaseView")
				break;
			case 95:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_RANK_VIEW, 0, 1)
				break;
			case 96:
				CompositeModel.GetInstance().Fire(CompositeEvent.OPEN_RED_VIEW, 0)
				break;
			case 97:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "ConstellationBaseView")
				break;
			case 98:
				EquipModel.GetInstance().Fire(EquipEvent.OPEN_VIEW, "EquipJewelCraveEnterView")
				break;
			case 99:
				KfHolyAreaModel.GetInstance().Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaEnterView")
				break;
			case 100:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_ROLE_SECOND_BUTTON, EquipmentViewSecond_Menu_Type.Skill, 2)
				break;
			case 101:
				//GlobalEventSystem:Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Soul)
				break;
			case 102:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_WELFARE_VIEW, 1)
				break;
			case 103:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@5")
				break;
			case 104:
				KfHolyAreaModel.GetInstance().Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaEnterView")
				break;
			case 105:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_BAG_VIEW, 0)
				break;
			case 106:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_BAG_VIEW, 1)
				break;
			case 107:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_ROLE_SECOND_BUTTON, EquipmentViewSecond_Menu_Type.Fashion, param)
				break;
			case 108:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "RedPacketCtrlView", { type: 100 })
				break;
			case 109:
				NoonPartyModel.GetInstance().Fire(NoonPEvent.ENTER_SCENE)
				break;
			case 110:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "SecretTreasureMainView", SecretTreasureMainViewIndex.Rune)
				break;
			case 111:
				MondaysAwardModel.GetInstance().Fire(MondaysAwardEvent.OPEN_VIEW, "MondaysAwardEntView")
				break;
			case 112:
				// local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "WorldBattleEnterView", CSPVPDefine.MODULE_ID)
				break;
			case 113:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "SecretTreasureMainView", SecretTreasureMainViewIndex.Unreal)
				break;
			case 115:
				KaifuActivityModel.GetInstance().topInvestOpenFun(investType.top)
				break;
			case 116:
				CompositeModel.GetInstance().Fire(CompositeEvent.OPEN_RED_VIEW, 2, null, param)
				break;
			case 117:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "SecretTreasureMainView", SecretTreasureMainViewIndex.Lung)
				break;
			case 118:
				// local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "SecretTreasureMainView", SecretTreasureMainViewIndex.Lung)
				LungModel.GetInstance().Fire(LungEvent.LUNG_OPEN_VIEW, "LungStoveMainView")
				break;
			case 119:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Equip)
				break;
			case 120:
				if (ViewManager.GetInstance().GetViewOpenState("DungeonEnterView")) {
					return
				}
				LungModel.GetInstance().Fire(LungEvent.LUNG_CLOSE_VIEW, "LungBagView")
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Dragon)
				break;
			case 121:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ILLUSION_VIEW, ...new_args)
				break;
			case 122:
				if (BabyModel.GetInstance().activeTime && BabyModel.GetInstance().activeTime > 0) {
					// BabyModel.GetInstance().Fire(BabyEvent.OPEN_VIEW, "BabyMainView", param[1], param[1])
					BabyModel.GetInstance().Fire(BabyEvent.OPEN_VIEW, "BabyMainView", param[0], param[1])
				} else {
					BabyModel.GetInstance().Fire(BabyEvent.OPEN_VIEW, "GestateBabyView")
				}
				break;
			case 123:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, window["MainFunc"].Role, window["RoleViewIndex"].MagicArr)
				break;
			case 124:
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_OUTWARD_ILLUSION_VIEW, enum_OutWardType.MagicArr)
				break;
			case 125:
				let func_is_open_125 = CommonManager.GetInstance().CheckFuncOpenState("GodEquipBuildView")
				if (func_is_open_125) {
					CompositeModel.GetInstance().Fire(CompositeEvent.OPEN_RED_VIEW, 1, null, param)
				}
				break;
			case 126:
				//local_GlobalEventSystem.Fire(local_EventName.SWITCH_MOUNT_PET_VIEW, 3)
				StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipMainView", StarEquipMainView.TabIndex.GodBefall)
				break;
			case 129:
				BabyModel.GetInstance().Fire(BabyEvent.OPEN_VIEW, "BabyMainView", 5)
				break;
			case 130:
				BabyModel.GetInstance().Fire(BabyEvent.OPEN_VIEW, "BabyMainView", 3)
				break;
			case 131:
				let func_is_open_131 = AdventureModel.GetInstance().CheckAdveOpenStatus()
				if (func_is_open_131) {
					AdventureModel.GetInstance().Fire(AdventureModel.OPEN_VIEW, "AdventureWindowView")
				}
				break;
			case 132:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@10", 65, param[1])
				break;
			case 133:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@10", 66, param[1])
				break;
			case 134:
				SurpriseGiftModel.GetInstance().Fire(SurpriseGiftModel.OPEN_VIEW, "SurpriseGiftBaseView")
				break;
			case 135:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.Mystery_Boss)
				break;
			case 136:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "CrossServerEnterView", EternityDefine.MODULE_ID)
				// Kf1vnModel.GetInstance().Fire(Kf1vnEvent.KF1VN_OPEN_VIEW, "CrossServerEnterView", EternityDefine.MODULE_ID)
				break;
			case 137:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_BAG_VIEW, BagModel.Index.Revelation)
				break;
			case 138:
				RuneTreasureModel.GetInstance().Fire(
					RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW,
					"RuneTreasureBaseView",
					RuneTreasureModel.ViewToIndex.PEAK
				)
				break;
			case 140:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.Diamond, param[1])
				break;
			case 141:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.Bind_Diamond, param[1])
				break;
			case 142:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.Honer, param[1])
				break;
			case 143:
				// local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.Outward, param[1])
				break;
			case 144:
				let open_data = KfHolyAreaModel.GetInstance().GetOpenState(true)
				if(open_data[0]){
					local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.MedalShop, param[1])
				}else{
					Message.show(`${open_data[1]}开启${OpenFun.OpenName(144)}`)
				}
				break;
			case 145:
				// local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.ExploitShop, param[1])
				break;
			case 146:
				//GlobalEventSystem:Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Pet, param[1])
				break;
			case 147:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_MOUNT_PET_VIEW, 3)
				break;
			case 148:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DemonSecondView", DemonDefine.SecondViewIndex.Painting)
				break;

			case 151:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DemonSecondView", DemonDefine.SecondViewIndex.Shop)
				break;
			case 152:
				OpenFun.OpenFunHandler(86)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_WEEKEND_ACTIVITY_VIEW, "EudaemonTaskView")
				break;
			case 153:
				if (BabyModel.GetInstance().activeTime > 0) {
					BabyModel.GetInstance().Fire(BabyEvent.OPEN_VIEW, "BabyMainView", 2)
				} else {
					BabyModel.GetInstance().Fire(BabyEvent.OPEN_VIEW, "GestateBabyView")
				}
				break;
			case 154:
				//GlobalEventSystem:Fire(local_EventName.OPEN_ACT_VIEW, "331@3", "424")
				break;
			case 155:
				KaifuActivityModel.GetInstance().topInvestOpenFun(investType.extreme)
				break;
			case 451:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_TOP_VIP_BASE_VIEW)
				break;
			case 156:
				MarketModel.GetInstance().Fire(MarketEvent.OPEN_VIEW, "MarketBaseView", 3)
				break;
			case 157:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.Domain_Boss, param[0])
				break;
			case 158:
				if (param) {
					CustomActivityModel.GetInstance().JumpAct(param[0], param[1])
				}
				break;
			case 159:
				//GlobalEventSystem:Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.AdvanExp)
				break;
			case 160:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.SingleRank)
				break;
			case 161:
				CompositeModel.GetInstance().Fire(CompositeModel.OPEN_COMPOSITE_VIEW, CompositeModel.Index.Guard)
				break;
			case 162:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_MEDAL_ENTER_VIEW, 1)
				break;
			case 163:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BossEnterView", BossModel.Index.Dragon_Boss, param[1])
				break;
			case 164:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_BAG_VIEW, BagModel.Index.Longlang)
				break;

			case 165:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "WorldBattleEnterView", BaseDungeonModel.MODULE_ID)
				break;
			case 166:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DemonRotaryView", 1)
				break;
			case 167:
				//GlobalEventSystem:Fire(local_EventName.OPEN_VIEW, "SecretTreasureMainView", SecretTreasureMainViewIndex.Soul)
				break;
			case 168:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.LonglangEx, param[1], param[1])
				break;
			case 169:
				local_GlobalEventSystem.Fire(
					local_EventName.OPEN_VIEW,
					"BattleFieldEnterView",
					BaseEnterDefine.BattleFieldIndex().HolyBattle
				)
				break;
			case 170:
				StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipMainView", StarEquipMainView.TabIndex.starEquip)
				break;
			case 171:
				// local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.Lucky, param[1], param[1])
				break;
			case 172:
				StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipMainView", StarEquipMainView.TabIndex.starEquip)
				StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipComView", param[1])
				break;
			case 173:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.GodCourt)
				break;
			case 174:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.TSCrack)
				// Kf1vnModel.GetInstance().Fire(Kf1vnEvent.KF1VN_OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.TSCrack)
				break;
			case 175:
				StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipMainView", StarEquipMainView.TabIndex.GodCourt)
				GodCourtModel.GetInstance().Fire(GodCourtModel.OPEN_VIEW, "GodCourtBagView", 1001, 1)
				break;
			case 176:
				if (GodCourtModel.GetInstance().IsGodCourtActive(1001)) {
					GodCourtModel.GetInstance().Fire(GodCourtModel.OPEN_VIEW, "GodHouseView")
				} else {
					StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipMainView", StarEquipMainView.TabIndex.GodCourt)
				}
				break;
			case 177:
				StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipMainView", StarEquipMainView.TabIndex.GodCourt)
				break;
			case 178:
				CompositeModel.GetInstance().Fire(CompositeModel.OPEN_COMPOSITE_VIEW, CompositeModel.Index.GodCourt)
				break;
			case 179:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "ConvoyBaseView")
				break;
			case 180:
				SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.OPEN_VIEW, "CountryBaseView", 1)
				break;
			case 181:
				let gmodel_181 = GuildModel.GetInstance()
				if (GuildModel.IsHasGuild()) {
					gmodel_181.Fire(GuildEvent.OPEN_VIEW, "GuildIdolBaseView", 0)
				} else {
					gmodel_181.Fire(GuildEvent.OPEN_VIEW, "GuildJoinBaseView")
				}
				break;
			case 182:
				SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.OPEN_VIEW, "CountryBaseView", 3)
				break;
			case 183:
				if (SeaHegemonyModel.GetInstance().actType == 1) {
					SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.OPEN_VIEW, "CountryBaseView", 3)
				} else {
					SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.OPEN_VIEW, "CountryBaseView", 5)
				}
				break;
			case 184:
				KaifuActivityModel.GetInstance().topInvestOpenFun(investType.king)
				break;
			case 185:
				KaifuActivityModel.GetInstance().topInvestOpenFun(investType.god)
				break;
			case 188:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@96", "96")
				break;
			case 189:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "SecretTreasureMainView", SecretTreasureMainViewIndex.Lung)
				LungModel.GetInstance().Fire(LungEvent.LUNG_OPEN_VIEW, "LungBagView", 1)
				break;
			case 190:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.DungeonPartner)
				break;
			case 191:
				KaifuActivityModel.GetInstance().Fire(KaifuActivityModelEvent.OPEN_KAIFUACTIVITYVIEW, 0)
				break;
			case 193:
			case 194:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIP_VIEW, 2)
				break;
			case 195:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "SecretTreasureMainView", SecretTreasureMainViewIndex.Unreal)
				break;
			case 196:
				SuitActivityModel.GetInstance().Fire(SuitActivityModel.OPEN_SUIT_VIEW)
				break;
			case 197:
				DailyModel.GetInstance().Fire(DailyEvent.OPEN_VIEW, "DailyView", 2)
				break;
			case 198:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "SecretTreasureMainView", SecretTreasureMainViewIndex.GodBeast)
				break;
			case 199:
				DailyModel.GetInstance().Fire(DailyEvent.OPEN_VIEW, "DailyView", 4)
				break;
			case 200:
				let open_day_200 = ServerTimeModel.GetInstance().GetOpenServerDay()
				if (open_day_200 < 8) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@3_1", 417)
				} else {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@3", 417)
				}
				break;
			case 201:
				SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.OPEN_VIEW, "CountryBaseView", 4)
				break;
			case 429:
				if (!TempleAwakenModel.GetInstance().GetFrontTaskComplete()) {
					Message.show("请先完成任务")
					return
				}
				if (TempleAwakenModel.GetInstance().GetTaskComplete()) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "TempleAwakenBaseView")
				} else {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "TempleAwakenEnterView")
					// local_GlobalEventSystem.Fire(SceneEventType.REQUEST_CHANGE_TO_AWAKEN_SCENE, 50006, null, null, null, null, null, () => {

					// }, 1)
				}
				break;
			case 202:
				RuneTreasureModel.GetInstance().Fire(
					RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW,
					"RuneTreasureBaseView",
					RuneTreasureModel.ViewToIndex.EXTREME
				)
				break;
			case 203: //装扮
				let args = [2, param[0], param[1]]
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_ROLE_SECOND_BUTTON, EquipmentViewSecond_Menu_Type.Fashion, args)
				break;
			case 204:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.Guild, param[0])
				break;
			case 205:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BossFieldSoulShopView")
				break;
			case 206:
				if (open_day > 7)
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.GhostWalk)
				else
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'WorldBattleEnterViewTwo', 1)

				break;
			case 223:
				FestivalModel.GetInstance().Fire(
					FestivalModelEvent.OPEN_FESTIVAL_VIEW,
					FestivalBaseView._layout_file,
					param[0]
				);
				break;
			case 41720: // 成长福利
				GrowthForceModel.GetInstance().Fire(
					GrowthForceModelEvent.OPEN_VIEW,
					GrowthForceView._layout_file,
					EnumGrowthForceViewType.eGrowingUp
				);
				break;
			case 224:
				EquipModel.GetInstance().Fire(EquipEvent.OPEN_VIEW, "EquipView", 4)
				break;
			case 225:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@58@0', 58, 0);
				break;
			case 226:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "TopVipBaseView")
				break;
			case 227://集字兑换
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@3', 4, 0);
				break;
			case 228://零元礼包
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@36@10', 2);
				break;
			case 229://天命转盘
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@99@1');
				break;
			case 230://限时抢购
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@100', 101, 0);
				break;
			case 231://特惠寻宝
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@100', 100, 0);
				break;
			case 232://超值特惠
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@100', "98");
				break;
			case 331112: // 冲榜特惠
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@110', "112");
				break;
			case 331116: // 冲榜夺宝
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@110', "116");
				break;
			case 233://幸运鉴宝
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@102@1');
				break;
			case 234://限时特惠
				PushGiftModel.GetInstance().Fire(
					PushGiftModel.OPEN_VIEW,
					'PushGiftEntView'
				);
				break;
			case 235://魂魔战场
				let heartBool = TaskModel.GetInstance().OpenHeartView()
				if (!heartBool) {
					Message.show("任务已结束")
				}
				break;
			case 332115: //一元秒杀
				if (ActivityIconManager.GetInstance().getIconInfo('331@115@0')) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@115@0');
				} else {
					Message.show("活动未开启")
				}
				break;
			case 236:
				if (open_day > 7)
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.SentientAct)
				else
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'WorldBattleEnterViewTwo')

				break;
			case 237:
				//限时爬塔活动
				BaseDungeonModel.GetInstance().OpenLimitTowerView()
				break;
			case 238:
				//结社协助
				if (GuildModel.IsHasGuild()) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "GuildHelpView")
				}
				else {
					Message.show("请先加入结社~")
				}
				break;
			case 239:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.Guild, param[0])
				break
			case 240:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, AutoBrushBaseView._layout_file, EnumAutoBrushTabType.eSoap)
				break
			case 452:
				if (!FirstRechargeModel.GetInstance().IsNoFirstRecharge())
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "WeekCardEnterView", param[0])
				else
					Message.show("购买首充后开启")
				break
			case 331110:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@110")
				break
			case 241:
				OnHookModel.GetInstance().Fire(OnHookModel.OPEN_VIEW, "OnHookMainView")
				break
			case 242:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, AutoBrushBaseView._layout_file, EnumAutoBrushTabType.eAutoBrush)
				break
			case 243:
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, window["MainFunc"].Role, window["RoleViewIndex"].BackOrnament)
				break;
			case 244:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "GuildGiftView")
				break;
			case 245:
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_OUTWARD_ILLUSION_VIEW, enum_OutWardType.BackOrnament)
				break;
			case 246:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.GhostWalk)
				break;
			case 247:
				GuildModel.GetInstance().Fire(GuildEvent.OPEN_VIEW, 'GuildMainBaseView');
				break
			case 248:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@128@0")
				break
			case 249:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@120@0")
				break
			case 250:
				KaifuActivityModel.GetInstance().Fire(KaifuActivityModelEvent.OPEN_KAIFUACTIVITYVIEW, 0)
				break
			case 251:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@128@2")
			case 252:
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DragonBallView")
				break
			case 253:
				let state = DragonBallModel.GetInstance().GetStatueActiveState()
				if(state){
					let gift_data = DragonBallModel.GetInstance().dragon_gift_data
					if(gift_data && gift_data.id){
						local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'DragonBallGiftView');
					}
					else{
						Message.show("活动暂未开启")
					}
				}else{
					Message.show("请先激活雕像")
				}
				break
			case 254:
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HaloMainView")
				break
		}

	}


	public static OpenName(jump_id) {
		if (jump_id == "331_49") {
			return "节日兑换"
		}

		jump_id = Number(jump_id)
		switch (jump_id) {
			case 1:
				return "主线副本"
			case 2:
				return "坐骑"
			case 3:
				return "羽翼"
			case 4:
			case 50:
				return "结社篝火"
			case 5:
				return "专属大妖"
			case 6:
				return "御魂副本"
			case 7:
				return "经验副本"
			case 8:
				return "Vip激活"
			case 9:
				return "装备强化界面"
			case 10:
				return "装备精炼界面"
			case 11:
				return "装备宝石界面"
			case 12:
				return "境界界面"
			case 13:
				return "御守"
			case 14:
				return "神器"
			case 15:
				return "侍魂"
			case 16:
				return "神巫"
			case 17:
				return "结社捐献界面"
			case 18:
				return "转职界面"
			case 19:
				return "VIP福利界面"
			case 20:
				return "VIP特权展示界面"
			case 21:
				return "充值"
			case 22:
				return "角色界面"
			case 23:
				return "VIP特权卡"
			case 24:
				return "装备套装界面"
			case 26:
				return "世界大妖"
			case 27:
				return "秘境大妖"
			case 28:
				return "大妖之境"
			case 29:
				return "专属大妖"
			case 30:
				return "套装首领"
			case 31:
				return "大妖"
			case 32:
				return "爬塔副本"
			case 33:
				return "结社争霸"
			case 34:
				return "每日签到"
			case 35:
				return "称号界面"
			case 36:
				return "蛮荒大妖"
			case 37:
				return "坐骑幻化系统"
			case 38:
				return "神巫幻化系统"
			case 39:
				return "侍魂幻化界面"
			case 40:
				return "神巫飞骑"
			case 41:
				return "翅膀幻化界面"
			case 42:
				return "御守幻化界面"
			case 43:
				return "神器幻化界面"
			case 44:
				return "图谱幻化界面"
			case 45:
				return "装备洗练界面"
			case 46:
				return "装备合成界面"
			case 47:
				return "背包神装界面"
			case 48:
				return "竞技场"
			case 49:
				return "九魂妖塔"
			case 51:
				return "战甲"
			case 52:
				return "魔法阵"
			case 53:
				return "资源副本"
			case 621:
				return "最强王者"
			case 55:
				return "祈愿"
			case 56:
				return "装备吞噬"
			case 57:
				return "求助好友"
			case 58:
				return "结社副本"
			case 59:
				return "成就"
			case 60:
				return "商城"
			case 61:
				return "月卡投资"
			case 62:
				return "等级投资"
			case 63:
				return "VIP投资"
			case 64:
				return "勾玉擂台"
			case 65:
				return "御魂召唤"
			case 66:
				return "装备夺宝"
			case 67:
				return "限时钜惠"
			case 68:
				return "异兽入侵"
			case 69:
				return "强化技能"
			case 70:
				return "首充"
			case 72:
				return "每日首充"
			case 73:
				return "决斗场"
			case 74:
				return "神兵租借"
			case 75:
				return "野外挂机"
			case 76:
				return "巅峰竞技"
			case 77:
				return "野外挂机"
			case 78:
				return "领地总览"
			case 79:
				return "领地称号"
			case 80:
				return "护送"
			case 81:
				return "领地夺宝"
			case 82:
				return "日常任务"
			case 83:
				return "异域商店"
			case 84:
				return "影装"
			case 85:
				return "姻缘副本"
			case 86:
				return "蜃气楼"
			case 87:
				return "抢购商城"
			case 88:
				return "异域"
			case 89:
				return "限时活动"
			case 90:
				return "戒镯升星"
			case 91:
				return "戒镯升阶"
			case 92:
				return "装备夺宝"
			case 93:
				return "结缘大厅"
			case 94:
				return "市场"
			case 95:
				return "榜单"
			case 96:
				return "神装"
			case 97:
				return "圣衣"
			case 98:
				return "宝石雕琢"
			case 99:
				return "跨服异域"
			case 100:
				return "天赋"
			case 101:
				return "源力副本"
			case 102:
				return "在线奖励"
			case 103:
				return "摇摇乐"
			case 104:
				return "跨服异域"
			case 108:
				return "结社红包"
			case 109:
				return "午间派对"
			case 110:
				return "御魂"
			case 111:
				return "周一大礼"
			case 112:
				return "跨服3v3"
			case 113:
				return "灵饰"
			case 114:
				return "灵饰副本"
			case 115:
				return "巅峰投资"
			case 116:
				return "神装加成"
			case 117:
				return "神纹"
			case 118:
				return "神纹召唤"
			case 119:
				return "寻装觅刃"
			case 120:
				return "神纹副本"
			case 121:
				return "幻形"
			case 122:
				return "宝宝"
			case 123:
				return "法阵"
			case 124:
				return "法阵"
			case 125:
				return "神装"
			case 126:
				return "神降"
			case 129:
				return "宝具夺宝"
			case 130:
				return "宝具"
			case 131:
				return "遗迹探宝"
			case 132:
				return "培养升阶"
			case 133:
				return "培养升战"
			case 135:
				return "秘境大妖"
			case 136:
				return "天启之源"
			case 137:
				return "天启装备"
			case 138:
				return "巅峰夺宝"
			case 140:
				return "勾玉商城"
			case 141:
				return "绑玉商城"
			case 142:
				return "荣耀商城"
			case 143:
				return "外观商城"
			case 144:
				return "异域商城"
			case 145:
				return "善缘商城"
			case 146:
				return "妖灵副本"
			case 147:
				return "妖灵"
			case 148:
				return "妖灵"
			case 151:
				return "妖灵黑市"
			case 10000:
				return "运营活动"
			case 152:
				return "帝国悬赏"
			case 153:
				return "宝宝幻化"
			case 154:
				return "契约之书"
			case 451:
				return "至尊Vip"
			case 155:
				return "至尊投资"
			case 156:
				return "拍卖"
			case 157:
				return "怨灵封印"
			case 159:
				return "高级经验副本"
			case 160:
				return "天境试炼"
			case 161:
				return "守护合成"
			case 162:
				return "动态头衔"
			case 163:
				return "神祭大妖"
			case 164:
				return "神祭"
			case 165:
				return "极限挑战"
			case 166:
				return "妖灵转盘"
			case 167:
				return "源力"
			case 168:
				return "神祭兑换"
			case 169:
				return "尊神战场"
			case 170:
				return "圣衣"
			case 171:
				return "幸运商店"
			case 172:
				return "圣衣合成"
			case 173:
				return "神社商店"
			case 174:
				return "时空圣痕"
			case 175:
				return "神社分解"
			case 176:
				return "神祈"
			case 177:
				return "神社"
			case 178:
				return "神社合成"
			case 179:
				return "节日护送"
			case 180:
				return "四海争霸"
			case 181:
				return "结社武魂"
			case 182:
				return "海域日常"
			case 183:
				return "海域"
			case 184:
				return "王者投资"
			case 185:
				return "神眷投资"
			case 188:
				return "大妖首杀"
			case 189:
				return "神纹商城"
			case 190:
				return "神巫副本"
			case 191:
				return "超值投资"
			case 192:
				return "寻宝"
			case 193:
				return "购买VIP"
			case 194:
				return "特权礼包"
			case 195:
				return "灵饰"
			case 196:
				return "传世名铠"
			case 197:
				return "璀璨之海"
			case 198:
				return "蜃妖"
			case 199:
				return "托管"
			case 200:
				return "冲级豪礼"
			case 202:
				return "至尊夺宝"
			case 429:
				return "觉醒之路"
			case 201:
				return "海域日常"
			case 203:
				return "装扮"
			case 204:
				return "善缘商店"
			case 205:
				return "战魂商店"
			case 206:
				return "百鬼夜行"
			case 223:
				return '祭典'
			case 224:
				return '神炼'
			case 225:
				return '赛博夺宝'
			case 226:
				return '至尊Vip'
			case 227://集字兑换
				return '集字兑换'
			case 228://零元礼包
				return '零元礼包'
			case 229://天命转盘
				return '天命转盘'
			case 230://限时抢购
				return '限时抢购'
			case 231://特惠寻宝
				return '特惠寻宝'
			case 232://超值特惠
				return '超值特惠'
			case 233://幸运鉴宝
				return '幸运鉴宝'
			case 234://限时特惠
				return '限时特惠'
			case 235://魂魔觉醒
				return '魂魔觉醒'
			case 237://限时爬塔
				return '限时爬塔'
			case 238:// 结社协助
				return '结社协助'
			case 239:
				return '武魂商店'
			case 240:
				return '法器'
			case 241:
				return '挂机'
			case 242:
				return '斩妖'
			case 41720:// 成长福利
				return '成长福利'
			case 452:
				return '周卡'
			case 331112: // 冲榜特惠
				return '冲榜特惠'
			case 243:
				return "背饰"
			case 244:
				return "公会-每日礼包"
			case 245:
				return "翅膀幻化界面"
			case 246:
				return "夜行商店"
			case 247:
				return "结社"
			case 248:
				return "绝版外显"
			case 249:
				return "超值礼包"
			case 250:
				return "周卡" // 超值投资内周卡
			case 251:
				return "绝版外显"
			case 252:
				return "龙玉"
			case 253:
				return "龙玉礼包"
			case 254:
				return "主角光环"
			default:
				return ""
		}
	}

	public static ActivityOpenName(jump_id) {
		let list = jump_id.toString().split("_")
		let type_id = 0
		if (list.length >= 2) {
			type_id = Number(list[1])
		}

		if (type_id == 98) {
			return "超值礼包"
		}

	}

	public static OpenIcon(jump_id) {
		jump_id = Number(jump_id)
		if (jump_id == 53) {
			return GameResPath.GetIcon("icon", "16")//`icon_json.16_png`
		}
		if ((jump_id == 60 || jump_id == 87) || jump_id >= 140 && jump_id <= 145) {
			return GameResPath.GetIcon("icon", "22") // `icon_json.22_png`
		}
		if (jump_id == 31) {
			return GameResPath.GetIcon("icon", "15")//`icon_json.15_png`
		}
		if (jump_id == 48) {
			return GameResPath.GetIcon("icon", "19")//`icon_json.19_png`
		}
		if (jump_id == 67) {
			return GameResPath.GetIcon("icon", "153")//`icon_json.153_png`
		}
		if (jump_id == 33) {
			return GameResPath.GetIcon("icon", "50500")
		}
		if (jump_id == 49) {
			return GameResPath.GetIcon("icon", "135")
		}
		if (jump_id == 70) {
			return GameResPath.GetIcon("icon", "159")
		}
		if (jump_id == 66) {
			return GameResPath.GetIcon("icon", "416")
		}
	}

	public static RequestOpen(jump_id) {
		if (jump_id == 1) {
			NineSkyModel.GetInstance().Fire(NineSkyModel.REQUEST_CCMD_EVENT, 13502)
		} else if (jump_id == 2) {
			NineSkyModel.GetInstance().Fire(NineSkyModel.REQUEST_CCMD_EVENT, 13502)
		}
		else if (jump_id == 3) {
			NoonPartyModel.GetInstance().Fire(NoonPEvent.ENTER_SCENE)
		}
		else if (jump_id == 4) {
			GuildActivityModel.GetInstance().Fire(GuildActEvent.REQUEST_PROTO, 40212)
		} else if (jump_id == 5) {
			GuildModel.GetInstance().Fire(GuildEvent.REQUEST_PROTO, 40230)
		} else if (jump_id == 6) {
			if (!CommonManager.GetInstance().CheckFuncOpenState("BattleFieldEnterView")) {
				return
			}
			OpenFun.OpenFunHandler(33)
			GuildFightModel.GetInstance().Fire(GuildFightEvent.GUILDFIGHT_OPEN_VIEW, "GuildFightMapView")
		} else if (jump_id == 7) {
			SnatchTreasureModel.GetInstance().Fire(SnatchTreasureModel.SCMD_REQUEST, 65202)
		}
		else if (jump_id == 8) {
			Kf1vnModel.GetInstance().Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62103)
		}
		else if (jump_id == 9) {
			HolyBattleModel.GetInstance().Fire(HolyBattleModel.REQUEST_PROTO, 21802)
		}
	}

	public static DiffCondOfChangeState(){
		let state = false
		if(!FirstRechargeModel.GetInstance().IsNoFirstRecharge()){ //周卡开启
			state = true
		}
		return state
	}

}
window["OpenFun"] = OpenFun