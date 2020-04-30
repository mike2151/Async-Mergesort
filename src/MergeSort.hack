namespace MergeSort\MergeSort;

require_once(__DIR__."/../vendor/autoload.hack");
use function HH\Lib\C\count;
use function HH\Lib\Vec\{drop, take};

async function merge_async(
  vec<num> $vec_1,
  vec<num> $vec_2,
): Awaitable<vec<num>> {
  $size_1 = count($vec_1);
  $size_2 = count($vec_2);
  if ($size_1 === 0) {
    return $vec_2;
  }
  if ($size_2 === 0) {
    return $vec_1;
  }
  $ptr_1 = 0;
  $ptr_2 = 0;
  $return_vec = vec[];
  while ($ptr_1 < $size_1 && $ptr_2 < $size_2) {
    $element_1 = $vec_1[$ptr_1];
    $element_2 = $vec_2[$ptr_2];
    if ($element_1 < $element_2) {
      $return_vec[] = $element_1;
      $ptr_1++;
    } else {
      $return_vec[] = $element_2;
      $ptr_2++;
    }
  }
  while ($ptr_1 < $size_1) {
    $element_1 = $vec_1[$ptr_1];
    $return_vec[] = $element_1;
    $ptr_1++;
  }
  while ($ptr_2 < $size_2) {
    $element_2 = $vec_2[$ptr_2];
    $return_vec[] = $element_2;
    $ptr_2++;
  }
  return $return_vec;
}

async function merge_sort_async(vec<num> $vec): Awaitable<vec<num>> {
  $size = count($vec);
  if ($size < 2) {
    return $vec;
  }
  $first_half = (int) ($size / 2);
  $vec_first_half = take($vec, $first_half);
  $vec_second_half = drop($vec, $first_half);
  concurrent {
    $sorted_first_half = await merge_sort_async($vec_first_half);
    $sorted_second_half = await merge_sort_async($vec_second_half);
  }
  return await merge_async($sorted_first_half, $sorted_second_half);
}

<<__EntryPoint>>
async function main_async(): Awaitable<noreturn> {
  \Facebook\AutoloadMap\initialize();
  $vec = vec[5, 4, 6, 3, 2];
  $sorted = await merge_sort_async($vec);
  foreach ($sorted as $element) {
    print($element . "\n");
  }
  exit(0);
}
