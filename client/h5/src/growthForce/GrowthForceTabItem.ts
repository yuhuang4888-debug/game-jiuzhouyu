import { ResManager } from '../common/ResManager';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { Util } from '../util/Util';
import { GameResPath } from '../util/GameResPath';
import { GrowthForceEvent, GrowthForceModel, GrowthForceModelEvent } from '../commonModel/GrowthForceModel';
import { GrowthBenefitsModel } from '../commonModel/GrowthBenefitsModel';

export class GrowthForceTabItem extends BaseItemRenderer {

    WIDTH = 226;
    HEIGT = 68;

    private _model: GrowthForceModel;
    private get GrowthForceModel() {
        return GrowthForceModel.GetInstance();
    }

    public constructor() {
        super();

        this.base_file = 'growthForce';
        this.layout_file = 'GrowthForceTabItem';
        this._model = GrowthForceModel.GetInstance();

        this.load_callback = () => {
            this.InitEvents();
        };

        this.Load();
    }

    private InitEvents() {
        // 点击页签
        let ClickTab = () => {
            if (this.data) {
                this.GrowthForceModel.Fire(GrowthForceModelEvent.TAB_SELECT, this.data, this.index);
            }
        }
        Util.AddClickEvent(this.btnBox, ClickTab, this);


        this.BindEvent(this._model, GrowthForceEvent.UPDATE_FIGHT_WELFARE, (is_new, reward_id) => {
            if (this.data?.type) {
                this.redImg.visible = GrowthForceModel.GetInstance().CheckFightWelfareRed()
            }
        })
    }


    public dataChanged() {
        if (super.dataChanged()) {
            let data: { type: number, red: boolean } = this.data;

            ResManager.GetInstance().SetImageSpriteTrans(
                this,
                this.bgImg,
                GameResPath.GetIcon("growthForce", this.selected ? "ui_fl_btn1" : "ui_fl_btn2")
            );

            this.nameLab.text = data.type ? '战力福利' : '成长福利';;
            this.nameLab.strokeColor = this.selected ? '#D57230' : '#D04130';
            this.redImg.visible = data.type ? GrowthForceModel.GetInstance().CheckFightWelfareRed() : GrowthBenefitsModel.GetInstance().GetDayRedDotStateAll();
        }
    }



    btnBox: Laya.Box
    bgImg: Laya.Image
    nameLab: Laya.Label
    redImg: Laya.Image
    public GetComponents() {
        [
            this.btnBox,
            this.bgImg,
            this.nameLab,
            this.redImg,
        ]
            = this.GetChildrenByNames([

                "btnBox",
                "bgImg",
                "nameLab",
                "redImg",
            ])
    }
}
window["GrowthForceTabItem"] = GrowthForceTabItem