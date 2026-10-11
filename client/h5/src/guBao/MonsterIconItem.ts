import { ResManager } from '../common/ResManager';
import { IS2CMosterParam, ISConfSoapDebris, MonsterModel, MonsterModelEvent } from '../commonModel/MonsterModel';
import { Util } from '../util/Util';
import { BaseItem1 } from './../common/BaseItem1';
import { ErlangParser } from './../util/ErlangParser';
export class MonsterIconItem extends BaseItem1 {


    private _debrisId: number = 0;
    private _index: number = 0;
    private _soapId: number = 0;
    private get monsterModel() {
        return MonsterModel.GetInstance();
    }

    public constructor(parent?) {
        super(parent)
        this.base_file = "monster"
        this.layout_file = "MonsterIconItem"

        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
        }
    }



    public InitEvent() {
        let ClickItem = () => {
            this.monsterModel.Fire(MonsterModelEvent.TAB_SELECT, this._debrisId, this._index);
        }
        Util.AddClickEvent(this.iconBox, ClickItem, this, true);

        // 选择icon回调
        this.BindEvent(this.monsterModel, MonsterModelEvent.SELECT_INDEX, (index: number) => {
            this.SelectIcon(index);
        });

    }

    public DeleteMe() {
        super.DeleteMe();
    }

    public SetData(info: any, soapId: number, index: number) {
        this._debrisId = info;
        this._index = index;
        this._soapId = soapId;
        if (this.is_loaded) {
            this.RenderView();
        }
    }

    public LoadSuccess() {
        this.RenderView();
    }

    private RenderView() {
        if (!this._debrisId || !this.is_loaded) {
            return;
        }

        let conf: ISConfSoapDebris = this.monsterModel.GetSoapConfBySoapIdAndDebrisId(this._soapId, this._debrisId);
        let cost = ErlangParser.GetInstance().parse(conf.cost)[0];
        let mosterParam: IS2CMosterParam = this.monsterModel.GetSoapsBySoapIdMap(this._soapId);
        let ids: { debris_id: number }[] = mosterParam?.debris_list || [];
        let index: number = ids?.findIndex((item: { debris_id: number }) => {
            return item.debris_id == this._debrisId;
        });
        let isAct: boolean = Boolean(index != -1);

        this.unlockImg.visible = !isAct;
        this.iconImg.gray = !isAct;
        ResManager.GetInstance().SetOutsideImageSprite(this, this.iconImg, "resource/game/goodsIcon/" + cost[1] + ".png");
        this.unlockLab.text = `第${this.monsterModel.GetGateByGoodsId(cost[1])}关获取`;
        this.redImg.visible = !isAct && this.monsterModel.GetDebrisRedDot(this._soapId, this._debrisId);
    }

    /**
     * 选中
     * @param index 索引
     */
    public SelectIcon(index: number) {
        if (!this.is_loaded) {
            return;
        }
        let bool: boolean = this._index == index;
        this.selectImg.visible = bool;
        // if (bool) {
        //     this.monsterModel.Fire(MonsterModelEvent.TAB_SELECT, this._debrisId, this._index);
        // }
    }


    iconBox: Laya.Box
    bgImg: Laya.Image
    iconImg: Laya.Image
    selectImg: Laya.Image
    unlockImg: Laya.Image
    unlockLab: Laya.Label
    redImg: Laya.Image
    public GetComponents() {
        [
            this.iconBox,
            this.bgImg,
            this.iconImg,
            this.selectImg,
            this.unlockImg,
            this.unlockLab,
            this.redImg,
        ]
            = this.GetChildrenByNames([

                "iconBox",
                "bgImg",
                "iconImg",
                "selectImg",
                "unlockImg",
                "unlockLab",
                "redImg",
            ])
    }
}
window["MonsterIconItem"] = MonsterIconItem