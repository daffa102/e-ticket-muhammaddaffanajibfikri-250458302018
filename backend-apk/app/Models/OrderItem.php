<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class OrderItem extends Model
{
    use HasFactory;
    protected $table = 'orders_items_';
    protected $guarded = ['id'];
    protected $fillable = [
        'order_id',
        'product_id',
        'quantity',
        'total_price',
    ];
        public function order()
        {
            return $this->belongsTo(Order::class);
        }
}
