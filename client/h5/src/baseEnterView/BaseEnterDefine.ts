import { BaseClass } from "../common/BaseClass"
import { TopPkModel } from "../commonModel/TopPkModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"

export class BaseEnterDefine extends BaseClass {

	//BaseEnterDefine.changeViewDay = 16

	public static BattleFieldIndex() {
		let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()


		if (open_day < TopPkModel.GetInstance().changeViewDay) {
			return { Arena:0, NineSky:1, HolyBattle:2, Top_Pk:3, GuildFight:4, DuelArena:999 }
		} else {
			return { Arena:0, NineSky:1, HolyBattle:2, Top_Pk:999, GuildFight:3, DuelArena:999 }
		}


	}
}

window["BaseEnterDefine"] = BaseEnterDefine