// TypeScript file
// 开放列表项
export class OpenItem {
	public constructor(_x: number = 0, _y: number = 0, _f: number = 0) {
		this.x = _x;
		this.y = _y;
		this.f = _f;
	}
	public x;
	public y;
	public f; // 当前点的g + h
	public CompareTo(other: OpenItem) {
		if (this.f < other.f)
			return -1;
		return 1;
	}
}
export class OpenItemHeap {
	m_data: Array<OpenItem>;
	m_size = 0;
	m_max_size = 0;
	public constructor() {
		this.m_size = 0;
		this.m_max_size = 0;
		this.Resize(128);
	}
	public Dispose() {
	}
	public Push(val: OpenItem) {
		let self = this;
		if (self.m_size == self.m_max_size)
			self.Resize(self.m_max_size * 2);
		let s = self.m_size;
		++self.m_size;
		while (s > 0) {
			let f = Math.floor((s - 1) / 2);
			if (!(val.CompareTo(self.m_data[f]) < 0))
				break;
			self.m_data[s] = self.m_data[f];
			s = f;
		}
		self.m_data[s] = val;
	}
	public PopFront() {
		let self = this;
		if (self.m_size == 0)
			return;
		--self.m_size;
		if (self.m_size == 0)
			return;
		let tmp: OpenItem = self.m_data[self.m_size];
		let f = 0;
		let half_size = Math.floor(self.m_size / 2);
		while (f < half_size) {
			let s = f * 2 + 1;
			if (s + 1 < self.m_size && self.m_data[s + 1].CompareTo(self.m_data[s]) < 0)
				++s;
			if (!(self.m_data[s].CompareTo(tmp) < 0))
				break;
			self.m_data[f] = self.m_data[s];
			f = s;
		}
		self.m_data[f] = tmp;
	}
	public Front() {
		if (this.m_size != 0) {
			return this.m_data[0];
		}
		return false;
	}
	public Size() {
		return this.m_size;
	}
	public Clear() {
		this.m_size = 0;
	}
	protected Resize(size) {
		let self = this;
		if (size <= self.m_max_size)
			return;
		let new_data: Array<OpenItem> = new Array(size);
		if (self.m_data != null) {
			for (let i = 0; i < self.m_data.length; i++) {
				new_data[i] = self.m_data[i];
			}
		}
		// {
		//	 Array.Copy(self.m_data, new_data, self.m_data.Length);
		// }
		self.m_data = new_data;
		self.m_max_size = size;
	}
}
window["OpenItemHeap"] = OpenItemHeap;
