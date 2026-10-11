import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseView1 } from "../common/BaseView1";
import { EquipmentItem } from "../common/EquipmentItem";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { EnumSubType, IS2CSuitListInfoParam, SuitModel } from "../commonModel/SuitModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class EquipSuitPreviewTips extends BaseView1 {
    static _layout_file: string = "EquipSuitPreviewTips";

    private _item: EquipmentItem;

    private _data: any;
    private suitType: number;
    private subType: number;


    private get suitModel() {
        return SuitModel.GetInstance();
    }

    public constructor() {
        super();

        this.base_file = 'suit';
        this.layout_file = 'EquipSuitPreviewTips';
        this.use_background = true;
        this.click_bg_toClose = true;
        this.is_center = true;
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;

        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
        };

        this.close_callback = () => {
            if (this._item) {
                this._item.DeleteMe();
                this._item = null;
            }
            this.ClearUIEffect(this.effBox);
        }

    }



    public InitEvent() {
        // 点击关闭
        Util.AddClickEvent(
            this.closeBtn,
            () => {
                this.Close();
            },
            this,
            true
        );
    }


    private LoadSuccess() {
        let res_mgr: ResManager = ResManager.GetInstance();
        res_mgr.SetTexture(this, this.bgImg, GameResPath.GetIconOtherPath("suit", "ui_merge_26"));
        res_mgr.SetTexture(this, this.bgImg1, GameResPath.GetIconOtherPath("suit", "ui_merge_27"));
        this.RenderViwe();
    }


    private RenderViwe() {
        this.RenderIcon();
    }



    private RenderIcon() {
        if (!this._item) {
            this._item = new EquipmentItem(this.iconBox, null, null, null, null, false);
            this._item.SetUseMask(true);
            this._item.Load();
        }
        let typeId: number = this._data.dynamic.type_id;
        let dynamic = this._data.dynamic;
        let data = this._data;

        this._item.SetShowTips(false);
        this._item.SetItemSize(85, 85);
        this._item.SetData(typeId);

        let confMaxSuitLv = this.suitModel.GetConfEquipMaxSuitLv(data.equip_type, this.suitType, this.subType);
        let conf = this.suitModel.GetConfSuitItemInfo(this.suitType, this.subType, confMaxSuitLv.slv);
        this.descLab.text = `打造至${conf.name}可激活炫酷特效`;
        let isEquip: boolean = this.suitModel.GetIsEquip(dynamic.equip_type);
        this.effBox.visible = isEquip;
        let box: Laya.Box = this.effBox;
        if (isEquip) {
            box.x = 284;
            box.y = 127;
            switch (this.subType) {
                case EnumSubType.eOne:
                    box.scaleX = 1;
                    box.scaleY = 1;
                    break;
                case EnumSubType.eTwo:
                    box.scaleX = 1.2;
                    box.scaleY = 1;
                    break;
                case EnumSubType.eThree:
                    box.scaleX = 1.2;
                    box.scaleY = 1.2;
                    break;
            }
            this.ClearUIEffect(this.effBox);
            let effName: string = this.suitModel.GetEffNameByType(this.suitType, this.subType);
            this.AddUIEffect(effName, this.effBox, null, 10, true);

        }

    }



    public Open(...new_args) {
        [this._data, this.suitType, this.subType] = [...new_args]
        super.Open();
    }

    public DeleteMe() {
        if (this._item) {
            this._item.DeleteMe();
            this._item = null;
        }
        this.ClearUIEffect(this.effBox);
        super.DeleteMe();
    }

    bgImg: Laya.Image
    closeBtn: Laya.Box
    iconBox: Laya.Box
    bgImg1: Laya.Image
    descLab: Laya.Label
    effBox: Laya.Box
    public GetComponents() {
        [
            this.bgImg,
            this.closeBtn,
            this.iconBox,
            this.bgImg1,
            this.descLab,
            this.effBox,
        ]
            = this.GetChildrenByNames([

                "bgImg",
                "closeBtn",
                "iconBox",
                "bgImg1",
                "descLab",
                "effBox",
            ])
    }
}
window["EquipSuitPreviewTips"] = EquipSuitPreviewTips