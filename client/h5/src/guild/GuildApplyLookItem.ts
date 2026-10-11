import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { CustomHeadItem } from '../common/CustomHeadItem';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { Util } from '../util/Util';

export class GuildApplyLookItem extends BaseItemRenderer {
    head: CustomHeadItem;
    model: GuildModel;
    data: ArrayElement<ProtoRecvVObj<40008>['apply_list']>;

    public WIDTH = 552;
    public HEIGT = 118;
    is_set = false;
    public constructor(parent) {
        super();

        this.model = GuildModel.GetInstance();

        this.base_file = 'guild';
        this.layout_file = 'GuildApplyLookItem';

        this.load_callback = () => {
            Util.AddClickEvent(this._btn_pass, this.onClickPass.bind(this), this, true);
            Util.AddClickEvent(this._btn_refuse, this.onClickRefuse.bind(this), this, true);

            if (!this.is_set) {
                this.SetData();
                this.is_set = true;
            }
        };

        this.Load();
    }

    onClickPass() {
        this.model.Fire(GuildEvent.REQUEST_PROTO, 40009, 'lc', this.data.role_id, 1);
    }
    onClickRefuse() {
        this.model.Fire(GuildEvent.REQUEST_PROTO, 40009, 'lc', this.data.role_id, 0);
    }

    public dataChanged() {
        if (!super.dataChanged()) return;

        if (this.is_loaded) {
            this.SetData();
            this.is_set = true;
        } else {
            this.is_set = false;
        }
    }

    SetData() {
        if (!this.data) return;
        let data = this.data;
        this._lb_name.text = data.name;

        let lv = (data.level > 370 && '神创' + (data.level - 370)) || data.level;
        this._lb_level.text = lv + '级';
        this._lb_fight.text = `${data.combat_power}`;

        if (!this.head) {
            this.head = new CustomHeadItem(this._playerHead);
            this.head.Load();
        }
        //let frame_id = DressModel.GetInstance().GetDressByType(this.data.dress_list, DressType.Photo)
        this.head.SetRoleVoData(this.data);
    }

    public DeleteMe() {
        if (this.head) {
            this.head.DeleteMe();
            this.head = null;
        }
        super.DeleteMe();
    }
    _Image111: Laya.Image;
    _playerHead: Laya.Box;
    _Label1: Laya.Label;
    _lb_fight: Laya.Label;
    _btn_refuse: Laya.Box;
    _Image11: Laya.Image;
    labelDisplay1: Laya.Label;
    _btn_pass: Laya.Box;
    _Image1: Laya.Image;
    labelDisplay: Laya.Label;
    _Group1: Laya.HBox;
    _lb_name: Laya.Label;
    _lb_level: Laya.Label;
    public GetComponents() {
        [this._Image111, this._playerHead, this._Label1, this._lb_fight, this._btn_refuse, this._Image11, this.labelDisplay1, this._btn_pass, this._Image1, this.labelDisplay, this._Group1, this._lb_name, this._lb_level] = this.GetChildrenByNames(['_Image111', '_playerHead', '_Label1', '_lb_fight', '_btn_refuse', '_Image11', 'labelDisplay1', '_btn_pass', '_Image1', 'labelDisplay', '_Group1', '_lb_name', '_lb_level']);
    }
}

window['GuildApplyLookItem'] = GuildApplyLookItem;
