import { BaseAwardItem } from '../common/BaseAwardItem';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { OpenFun } from '../common/OpenFun';
import { ResManager } from '../common/ResManager';
import { EnumFestivalProtocol } from '../commonController/FestivalController';
import { FestivalModel, FestivalModelEvent, ICConfFiestaTask, IS2CFestivalTaskInfo } from '../commonModel/FestivalModel';
import { GameResPath } from '../util/GameResPath';
import { TransformCurrency, Util } from '../util/Util';
import { FestivalTaskView } from './FestivalTaskView';
export class FestivalTaskListItem extends BaseItemRenderer {

    getBtn: Laya.Box
    jumpBtn: Laya.Box
    iconBox: Laya.Box
    titleLab: Laya.Label
    timesLab: Laya.Label
    valueLab: Laya.Label
    numLab: Laya.Label
    barImg: Laya.Image
    receivedImg: Laya.Image
    redImg: Laya.Image
    imgBg1: Laya.Image
    imgBg2: Laya.Image

    WIDTH = 675
    HEIGT = 123

    private item1: BaseAwardItem;

    private get FestivalModel() {
        return FestivalModel.GetInstance();
    }

    public constructor() {
        super();
        this.base_file = 'festival';
        this.layout_file = 'FestivalTaskListItem';
        this.load_callback = () => {

            if (!this.item1) {
                this.item1 = new BaseAwardItem(this.iconBox);
                this.item1.Load();
                this.item1.SetItemSize(80, 80);
                this.item1.SetItembgVisible(false);
            }

            this.InitEvents();
            this.LoadSuccess();
        };
        this.Load();
    }

    public dataChanged() {
        if (super.dataChanged()) {
            let data: IS2CFestivalTaskInfo = this.data;
            let conf: ICConfFiestaTask = this.FestivalModel.GetSingleConfFiestaTask(data.task_id);
            let taskTimes: number = conf.times - data.finish_times;

            this.numLab.text = `${'X' + conf.exp}`;
            this.titleLab.text = conf.desc;
            this.timesLab.text = `(剩余可完成${taskTimes}次)`;
            this.timesLab.visible = conf.times > 1 && taskTimes >= 1;
            let barW: number = (data.cur_num / conf.target_num) * 304;
            this.barImg.width = barW > 304 ? 304 : barW;
            // 指定任务类型更改显示
            this.valueLab.text = conf.content == '累充' ? `${ TransformCurrency(data.cur_num)} /  ${TransformCurrency(conf.target_num)}` : `${data.cur_num}/${+ conf.target_num}`;


            this.jumpBtn.visible = data.status == 0; // 未完成
            this.getBtn.visible = data.status == 1; // 未领取
            this.receivedImg.visible = data.status == 2; // 已领取

            this.redImg.visible = data.status == 1; // 未领取

            if (!this.item1) {
                this.item1 = new BaseAwardItem(this.iconBox);
            }
            this.item1.Load();
            this.item1.SetItemSize(80, 80);
            this.item1.SetData(37120001);
        }
    }

    private InitEvents() {
        // 跳转
        let GoJump = () => {
            if (this.data) {
                let conf: ICConfFiestaTask = this.FestivalModel.GetSingleConfFiestaTask(this.data.task_id);
                OpenFun.OpenFunHandler(conf.link_id);
                this.FestivalModel.Fire(FestivalModelEvent.CLOSE_FESTIVAL_VIEW, FestivalTaskView._layout_file);
            }
        }
        Util.AddClickEvent(this.jumpBtn, GoJump, this, true);

        // 领取奖励
        let GetAward = () => {
            if(!this.data) return
            let conf: ICConfFiestaTask = this.FestivalModel.GetSingleConfFiestaTask(this.data.task_id);
            this.FestivalModel.Fire(
                FestivalModelEvent.FESTIVAL_REQUEST_PROTO, EnumFestivalProtocol.eProtocol19404, 'ch', conf.type, conf.id
            );
        }

        Util.AddClickEvent(this.getBtn, GetAward, this, true);

    }

    private LoadSuccess() {
        ResManager.GetInstance().SetTexture(
            this,
            this.imgBg1,
            GameResPath.GetIconOtherPath('festival', 'ui_db_jd011')
        );
        ResManager.GetInstance().SetTexture(
            this,
            this.imgBg2,
            GameResPath.GetIconOtherPath('festival', 'ui_db_jd01')
        );
    }

    public DeleteMe() {
        if (this.item1) {
            this.item1.DeleteMe();
            this.item1 = null;
        }
        super.DeleteMe();
    }




    public GetComponents() {
        [
            this.getBtn,
            this.jumpBtn,
            this.iconBox,
            this.titleLab,
            this.timesLab,
            this.valueLab,
            this.numLab,
            this.barImg,
            this.receivedImg,
            this.redImg,
            this.imgBg1,
            this.imgBg2,
        ]
            = this.GetChildrenByNames([

                "getBtn",
                "jumpBtn",
                "iconBox",
                "titleLab",
                "timesLab",
                "valueLab",
                "numLab",
                "barImg",
                "receivedImg",
                "redImg",
                "imgBg1",
                "imgBg2",
            ])
    }
}
window["FestivalTaskListItem"] = FestivalTaskListItem