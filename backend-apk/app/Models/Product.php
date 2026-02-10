<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use App\Models\Category;

class Product extends Model
{
    use HasFactory;
    protected $table = 'products';

    protected $guarded = ['id'];

    public function category(){
        return $this->belongsTo(Category::class);
    }

    public function image(): Attribute {
        return Attribute::make(
            get: fn ($image) => $image ? url('/storage/' . $image) : null,
        );
    }

    protected $fillable = [
        'name',
        'price',
        'stock',
        'category_id',
        'image',
    ];
}
