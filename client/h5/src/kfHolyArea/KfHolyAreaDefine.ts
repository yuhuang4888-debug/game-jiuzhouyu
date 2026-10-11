import { BaseClass } from "../common/BaseClass"
import { ColorUtil, ColorType } from "../util/ColorUtil"

export class KfHolyAreaDefine extends BaseClass {
	public static RefreshSceneDataTime = 10
	public static TotalScore = 150
	public static Module_Id = 284
	public static Examination_Range = 600
	public static Blserver_Color = ColorUtil.GetColorDark(ColorType.BLUE)
	public static Before_Blserver_Color = "'#ee4e00'"
	public static Special_Score_Type = 36255012
	public static Bind_Diamond_type = 2
	public static Diamond_type = 1
	public static BuildRes = [
		"uikfsy_032",
		"uikfsy_031",
		"uikfsy_030"
	]
	public static BtnRes = {
		[1]:
			{ light: "kfHolyArea_asset.uikfsy_041a", dark: "kfHolyArea_asset.uikfsy_041b" },
		[2] : {light : "kfHolyArea_asset.uikfsy_040a", dark : "kfHolyArea_asset.uikfsy_040b"},
		[3] : {light : "kfHolyArea_asset.uikfsy_039a", dark : "kfHolyArea_asset.uikfsy_039b"},
		[999] : {light : "kfHolyArea_asset.uikfsy_042a", dark : "kfHolyArea_asset.uikfsy_042b"}
	}
	public static NoticeIconShowDay = -1

}
window["KfHolyAreaDefine"] = KfHolyAreaDefine