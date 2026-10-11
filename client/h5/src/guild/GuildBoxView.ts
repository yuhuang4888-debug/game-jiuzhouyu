import { BaseAwardItem } from '../common/BaseAwardItem';
import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { GoodsModel } from '../commonModel/GoodsModel';
import { GuildModel } from '../commonModel/GuildModel';

export class GuildBoxView extends BaseView1 {
    tips = '';
    use_background = true;
    click_bg_toClose = true;
    is_center = true;
    show_open_movie = true;
    destroy_imm = true;
    item_list = [];
    _group_data;
    _lb_tips;
    destroy_callback;
    model: GuildModel;
    open_callback;
    goods_list;
    public constructor() {
        super();

        this.model = GuildModel.GetInstance();
        this.base_file = 'guild';
        this.layout_file = 'GuildBoxViewExml';
        this.layer_value = Enum_UILayer.Activity;
        this.open_callback = () => {
            this.InitView();
        };

        this.destroy_callback = () => {
            this.Clear();
        };
    }

    public Open(...new_args) {
        [this.goods_list, this.tips] = new_args;
        super.Open();
    }

    Clear() {
        for (let key in this.item_list) {
            // [ts2lua]item_list下标访问可能不正确
            this.item_list[key].DeleteMe();
        }
        this.item_list = [];
    }

    InitView() {
        this.UpdateAwardItems();
        this._lb_tips.text = this.tips || '';
    }

    UpdateAwardItems() {
        if (!this.goods_list) {
            return;
        }
        let gmodel = GoodsModel.GetInstance();
        let i = 0;
        do {
            let info = this.goods_list[i];
            let item = this.item_list[i];
            if (!item) {
                item = new BaseAwardItem(this._group_data);
                item.Load();
                this.item_list[i] = item;
            }
            let type_id,
                lock = gmodel.GetMappingTypeId(info[0], info[1]);
            item.SetData(type_id, info[2], lock);
            item.SetVisible(true);
            i = i + 1;
        } while (i < this.goods_list.length);
        let j = this.goods_list.length;
        do {
            this.item_list[j].SetVisible(false);
            j = j + 1;
        } while (j < this.item_list.length);
    }
}

window['GuildBoxView'] = GuildBoxView;
