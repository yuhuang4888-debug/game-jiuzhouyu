import { ResManager } from '../common/ResManager';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { Util } from '../util/Util';
import { GameResPath } from '../util/GameResPath';
import { GrowthBenefitsModel, GrowthBenefitsModelEvent } from '../commonModel/GrowthBenefitsModel';
import { RoleManager } from './../commonModel/RoleManager';
import { WordManager } from '../common/WordManager';
import { Message } from './../sysInfo/SysInfoController';

export class GrowthBenefitsTabItem extends BaseItemRenderer {

    WIDTH = 149;
    HEIGT = 76;


    private get GrowthBenefitsModel() {
        return GrowthBenefitsModel.GetInstance();
    }

    public constructor() {
        super();

        this.base_file = 'growthBenefits';
        this.layout_file = 'GrowthBenefitsTabItem';

        this.load_callback = () => {
            this.InitEvents();
        };

        this.Load();
    }



    private InitEvents() {
        // 点击页签
        let ClickTab = () => {
            if (this.data) {
                let curRoleDay: number = RoleManager.GetInstance().GetRoleCreateDay() + 1;
                if (curRoleDay >= this.data.day) {
                    this.GrowthBenefitsModel.Fire(GrowthBenefitsModelEvent.TAB_SELECT, this.data, this.index);
                } else {
                    Message.show(`第${WordManager.NumConvertStage(this.data.day)}天解锁`)
                }
            }
        }







        Util.AddClickEvent(this.btnBox, ClickTab, this);
    }


    public dataChanged() {
        if (super.dataChanged()) {
            let data: { day: number, red: boolean } = this.data;
            // 当前创角天数
            let curRoleDay: number = RoleManager.GetInstance().GetRoleCreateDay() + 1;
            if (curRoleDay >= data.day) {
                this.nameLab.color = this.selected ? '#FFFFFF' : '#4F538F';
                this.nameLab.strokeColor = this.selected ? '#AD455C' : '#C6C3F4';
                ResManager.GetInstance().SetImageSpriteTrans(
                    this,
                    this.bgImg,
                    GameResPath.GetIcon("growthBenefits", this.selected ? "ui_fl_07" : "ui_fl_08")
                );
                this.nameLab.text = `第${WordManager.NumConvertStage(data.day)}天`;
                this.compImg.visible = this.GrowthBenefitsModel.GetTaskDayIsAllReceive(data.day);
            } else {
                this.nameLab.color = '#525252';
                this.nameLab.strokeColor = '#CECECE';
                ResManager.GetInstance().SetImageSpriteTrans(
                    this,
                    this.bgImg,
                    GameResPath.GetIcon("growthBenefits", "ui_fl_09")
                );
                this.nameLab.text = `未解锁`;
                this.compImg.visible = false
            }

            this.redImg.visible = data.red;
        }
    }




    btnBox: Laya.Box
    bgImg: Laya.Image
    nameLab: Laya.Label
    redImg: Laya.Image
    compImg: Laya.Image
    public GetComponents() {
        [
            this.btnBox,
            this.bgImg,
            this.nameLab,
            this.redImg,
            this.compImg,
        ]
            = this.GetChildrenByNames([

                "btnBox",
                "bgImg",
                "nameLab",
                "redImg",
                "compImg",
            ])
    }
}
window["GrowthBenefitsTabItem"] = GrowthBenefitsTabItem