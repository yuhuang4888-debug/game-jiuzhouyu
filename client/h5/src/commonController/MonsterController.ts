import { BaseController } from "../common/BaseController";
import { EventName } from "../common/EventName";
import { RedDotController } from "../common/RedDotController";
import { RedKey } from "../common/RedDotDefine";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MonsterModel, MonsterModelEvent } from "../commonModel/MonsterModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Util } from "../util/Util";

export enum EnumMonsterProtocol {
	eProtocol13320 = 13320,
	eProtocol13321,
}

export class MonsterController extends BaseController {
	private InitInfo: Function;
	private InitEvents: Function;

	private get monsterModel() {
		return MonsterModel.GetInstance();
	}

	public constructor() {
		super();

		let UMSG = UserMsgAdapter.GetInstance();
		this.InitEvents = () => {
			// 协议发送
			this.monsterModel.Bind(
				MonsterModelEvent.REQUEST_PROTO,
				(id: number, fmt: string, ...new_args) => {
					this.SendFmtToGame(id, fmt, ...new_args);
				}
			);

			GlobalEventSystem.Bind(EventName.GAME_START, () => {
				RedDotController.ins.up(RedKey.MONSTER_SOAP, 0);
				this.monsterModel.ClearSoapsBySoapMap();
				this.monsterModel.InitConfig();
				this.SendFmtToGame(EnumMonsterProtocol.eProtocol13320);
			});


			GoodsModel.GetInstance().Bind(GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				this.monsterModel.UpdateSoapRedDot()
			});

			GoodsModel.GetInstance().Bind(GoodsModel.CREATE_BAG_LIST_FINISH, (goods_list?) => {
				this.monsterModel.UpdateSoapRedDot()
			});

		};

		this.InitInfo = () => {
			let On13320 = () => {
				let scmd = UMSG.GetSCMD(EnumMonsterProtocol.eProtocol13320)
				this.monsterModel.combat = scmd.combat;
				for (const iterator of scmd.soap_list) {
					this.monsterModel.SetSoapsBySoapIdMap(iterator);
				}
				this.monsterModel.UpdateSoapRedDot()
				this.monsterModel.Fire(MonsterModelEvent.INIT);
			}


			let On13321 = () => {
				let scmd = UMSG.GetSCMD(EnumMonsterProtocol.eProtocol13321)
				if (scmd.errcode == 1) {
					this.monsterModel.combat = scmd.combat;
					this.monsterModel.SetSoapsBySoapIdMap({ soap_id: scmd.soap_id, debris_list: scmd.debris_list });
					this.monsterModel.Fire(MonsterModelEvent.ACTIVALTION);
					this.monsterModel.UpdateSoapRedDot()
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}


			this.RegisterProtocal(EnumMonsterProtocol.eProtocol13320, On13320);
			this.RegisterProtocal(EnumMonsterProtocol.eProtocol13321, On13321);
		};

		this.InitInfo();
		this.InitEvents();
	}
}
window['MonsterController'] = MonsterController;
